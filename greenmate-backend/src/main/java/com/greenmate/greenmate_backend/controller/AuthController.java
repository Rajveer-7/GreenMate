package com.greenmate.greenmate_backend.controller;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.greenmate.greenmate_backend.model.AppUser;
import com.greenmate.greenmate_backend.repository.AppUserRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AppUserRepository userRepository;

    @PostMapping("/verify")
    public ResponseEntity<AppUser> verifyToken(@RequestBody Map<String, String> request) {
        String idToken = request.get("idToken");

        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String firebaseUid = decodedToken.getUid();
            String email = decodedToken.getEmail();

            Optional<AppUser> existingUser = userRepository.findByFirebaseUid(firebaseUid);

            AppUser user = existingUser.orElseGet(() -> {
                AppUser newUser = AppUser.builder()
                    .firebaseUid(firebaseUid)
                    .email(email)
                    .registeredAt(LocalDateTime.now())
                    .build();
                return userRepository.save(newUser);
            });

            return ResponseEntity.ok(user);

        } catch (FirebaseAuthException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}
