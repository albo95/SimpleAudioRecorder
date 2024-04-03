
import Foundation

final class TranscriptionManager {
    static let shared = TranscriptionManager()
    
    var openAIKey: String {
        get {
            UserDefaults.standard.string(forKey: "OpenAI_APIKey") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OpenAI_APIKey")
            NotificationCenter.default.post(name: .didChangeOpenAIKey, object: nil)
        }
    }
    
    private let session = URLSession.shared
    
    private init() {
        self.registerForOpenAIKeyChanges()
    }
    
    enum TranscriptionError: Error {
        case invalidURL
        case encodingError
        case serverError(statusCode: Int)
        case networkError(Error)
        case dataError
    }
    
    func transcribeRecording(recording: Recording) async throws -> String {
        guard let audioData = recording.audioData else {
            throw TranscriptionError.dataError
        }
        
        let url = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createRequestBody(with: audioData, boundary: boundary, fileName: recording.fileURL?.lastPathComponent ?? "audio")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw TranscriptionError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        guard let result = String(data: data, encoding: .utf8) else {
            throw TranscriptionError.encodingError
        }
        
        return result
    }
    
    private func createRequestBody(with audioData: Data, boundary: String, fileName: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: audio/mpeg\r\n\r\n")
        body.append(audioData)
        body.appendString("\r\n")
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"model\"\r\n\r\nwhisper-1\r\n")
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"response_format\"\r\n\r\ntext\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerForOpenAIKeyChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(openAIKeyChanged), name: .didChangeOpenAIKey, object: nil)
    }
    
    @objc private func openAIKeyChanged() {
        // Handle the OpenAI key change if needed, e.g., invalidate sessions or caches.
    }
}


extension Notification.Name {
    static let didChangeOpenAIKey = Notification.Name("didChangeOpenAIKey")
}


private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

