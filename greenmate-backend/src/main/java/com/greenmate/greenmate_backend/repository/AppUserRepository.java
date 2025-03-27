package com.greenmate.greenmate_backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.greenmate.greenmate_backend.model.AppUser;

@Repository
public interface AppUserRepository extends JpaRepository<AppUser, Long> {
	
    Optional<AppUser> findByFirebaseUid(String firebaseUid);

	

}
