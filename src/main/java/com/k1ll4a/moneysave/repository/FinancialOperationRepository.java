package com.k1ll4a.moneysave.repository;

import com.k1ll4a.moneysave.domain.FinancialOperation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface FinancialOperationRepository extends JpaRepository<FinancialOperation, UUID> {
    List<FinancialOperation> findByUserIdAndOperationDateBetween(UUID userId, LocalDate startDate, LocalDate endDate);

    List<FinancialOperation> findTop10ByUserIdOrderByOperationDateDescCreatedAtDesc(UUID userId);
}
