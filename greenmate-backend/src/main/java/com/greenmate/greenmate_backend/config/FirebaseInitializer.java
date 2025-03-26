package com.greenmate.greenmate_backend.config;

import java.io.FileInputStream;

import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

@Component
public class FirebaseInitializer {
	
	@PostConstruct
    public void initialize() {
        try {
            FileInputStream serviceAccount = new FileInputStream(
                "src/main/resources/firebase/greenmate-firebase-adminsdk.json");

            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}