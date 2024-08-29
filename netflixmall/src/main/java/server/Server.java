package server;

import org.java_websocket.server.WebSocketServer;
import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;

import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.Map;

public class Server extends WebSocketServer {

    private Map<String, WebSocket> clients = new HashMap<String, WebSocket>();

    public Server(InetSocketAddress address) {
        super(address);
    }

    @Override
    public void onOpen(WebSocket conn, ClientHandshake handshake) {
        // 클라이언트를 등록
        clients.put(conn.getRemoteSocketAddress().toString(), conn);
        System.out.println("New connection: " + conn.getRemoteSocketAddress());
    }

    @Override
    public void onClose(WebSocket conn, int code, String reason, boolean remote) {
        // 클라이언트를 제거
        clients.remove(conn.getRemoteSocketAddress().toString());
        System.out.println("Connection closed: " + conn.getRemoteSocketAddress());
    }

    @Override
    public void onMessage(WebSocket conn, String message) {
        // 메시지 처리 로직을 여기에 추가
    }

    @Override
    public void onError(WebSocket conn, Exception ex) {
        ex.printStackTrace();
    }

    @Override
    public void onStart() {
        System.out.println("Server started successfully");
    }

    // 사용자를 블락 처리하고, 해당 사용자에게 블락 메시지를 전송
    public void blockUser(String username) {
        for (WebSocket conn : clients.values()) {
            // 사용자 ID에 따라 블락 메시지를 전송
            conn.send("{\"type\": \"block\", \"username\": \"" + username + "\"}");
        }
    }

    public static void main(String[] args) {
        WebSocketServer server = new Server(new InetSocketAddress(8887));
        server.start();
    }
}

