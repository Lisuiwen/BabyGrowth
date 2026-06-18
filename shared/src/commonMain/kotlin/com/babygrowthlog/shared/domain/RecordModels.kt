package com.babygrowthlog.shared.domain

import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

/**
 * 所有宝宝记录的公共审计字段，支持多人协作和后续同步冲突处理。
 */
@Serializable
data class AuditInfo(
    val createdBy: String,
    val createdByName: String,
    val createdAt: Instant,
    val updatedBy: String,
    val updatedAt: Instant,
)

/**
 * 喂养记录保持表单轻量，混合喂养只在统计层聚合判定。
 */
@Serializable
data class FeedingRecord(
    val id: String,
    val babyId: String,
    val happenedAt: Instant,
    val method: FeedingMethod,
    val amountMl: Int? = null,
    val note: String? = null,
    val audit: AuditInfo,
)

/**
 * 喂养方式枚举和产品表单一一对应，避免首版出现超长混合表单。
 */
@Serializable
enum class FeedingMethod {
    DIRECT_BREASTFEEDING,
    BOTTLE_BREAST_MILK,
    FORMULA,
    OTHER,
}

/**
 * 睡眠记录支持正在睡和已结束两种状态，用于 5 小时溢出保护。
 */
@Serializable
data class SleepRecord(
    val id: String,
    val babyId: String,
    val startedAt: Instant,
    val endedAt: Instant? = null,
    val status: SleepStatus,
    val audit: AuditInfo,
)

/**
 * 睡眠状态枚举用于本地统计和同步后的冲突判定。
 */
@Serializable
enum class SleepStatus {
    SLEEPING,
    FINISHED,
}

