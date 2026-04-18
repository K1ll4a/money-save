package com.k1ll4a.moneysave;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;


@SpringBootApplication
public class ApiTestApplication {

	public static void main(String[] args) throws IOException {
		SpringApplication.run(ApiTestApplication.class, args);
		
	}

}
