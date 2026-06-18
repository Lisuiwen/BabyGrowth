package com.babygrowthlog.shared.sync

import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

/**
 * 同步信封用于本地优先架构，后端可以按实体类型和更新时间做增量同步。
 */
@Serializable
data class SyncEnvelope<T>(
    val entityType: String,
    val entityId: String,
    val updatedAt: Instant,
    val payload: T,
)

/**
 * 同步结果保留冲突列表，首版默认最后更新时间优先，但不丢失冲突证据。
 */
@Serializable
data class SyncResult(
    val acceptedCount: Int,
    val conflictIds: List<String> = emptyList(),
)

