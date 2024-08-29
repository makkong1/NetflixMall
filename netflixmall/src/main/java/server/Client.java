package server;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.net.URI;

public class Client extends WebSocketClient {

    public Client(URI serverUri) {
        super(serverUri);
    }

    @Override
    public void onOpen(ServerHandshake handshakedata) {
        System.out.println("Connected to server");
    }

    @Override
    public void onMessage(String message) {
        // JSON 파싱을 통해 메시지 타입 확인
        if (message.contains("\"type\": \"block\"")) {
            // 블락 메시지 처리 로직
            System.out.println("You have been blocked. Logging out...");
            // 예: 사용자 로그아웃 처리
            logout();
        } else {
            System.out.println("Message from server: " + message);
        }
    }

    @Override
    public void onClose(int code, String reason, boolean remote) {
        System.out.println("Disconnected from server");
    }

    @Override
    public void onError(Exception ex) {
        ex.printStackTrace();
    }

    private void logout() {
        // 로그아웃 로직 구현	
        System.out.println("Performing logout...");
    }

    public static void main(String[] args) {
        try {
            WebSocketClient client = new Client(new URI("ws://localhost:8887"));
            client.connect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
