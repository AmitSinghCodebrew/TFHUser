//
//  APIConstants.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

internal struct APIConstants {
    static let login = "api/login"
    static let register = "api/register"
    static let profileUpdate = "api/profile-update"
    static let uploadImage = "api/upload-image"
    static let updatePhone = "api/update-phone"
    static let updateFCMId = "api/update-fcm-id"
    static let forgotPsw = "api/forgot_password"
    static let changePsw = "api/password-change"
    static let logout = "api/app_logout"
    static let sendOTP = "api/send-sms"
    static let categories = "api/categories"
    static let requests = "api/requests-cs"
    static let vendorList = "api/doctor-list"
    static let vendorDetail = "api/doctor-detail"
    static let getFilters = "api/get-filters"
    static let banners = "api/banners"
    static let transactionHistory = "api/wallet-history"
    static let wallet = "api/wallet"
    static let cards = "api/cards"
    static let addMoney = "api/add-money"
    static let addCard = "api/add-card"
    static let createRequest = "api/create-request"
    static let notifications = "api/notifications"
    static let services = "api/services"
    static let addReview = "api/add-review"
    static let getReviews = "api/review-list"
    static let deleteCard = "api/delete-card"
    static let updateCard = "api/update-card"
    static let coupons = "api/coupons"
    static let confirmRequest = "api/confirm-request"
    static let getSlots = "api/get-slots"
    static let classes = "api/classes"
    static let enrollUser = "api/enroll-user"
    static let classJoin = "api/class/join"
    static let cancelRequest = "api/cancel-request"
    static let callStatus = "api/call-status"
    static let makeCall = "api/make-call"
    static let appVersion = "api/appversion"
    static let pages = "api/pages"
    static let clientDetail = "api/clientdetail"
    static let countryData = "api/countrydata"
    static let packages = "api/pack-sub"
    static let feeds = "api/feeds"
    static let addFav = "api/feeds/add-favorite"
    static let viewFeed = "api/feeds/view"
    static let home = "api/home"
    static let addComment = "api/feeds/add-comment"
    static let getComments = "api/feeds/comments"
    static let addLike = "api/feeds/add-like"
    static let askQuestions = "api/ask-questions"
    static let orderCreate = "api/order/create"
    static let razorPayWebhook = "api/razor-pay-webhook"
    static let supportPackages = "api/support-packages"
    static let symptoms = "api/symptoms"
    static let updateRequestSymptoms = "api/update-request-symptoms"
    static let waterLimit = "api/water-limit"
    static let drinkWater = "api/drink-water"
    static let pdf = "generate-pdf"
    static let addFamily = "api/add-family"
    static let proteinLimit = "api/protein-limit"
    static let drinkProtein = "api/drink-protein"
    static let hyperPayWebHook = "api/webhook/hyperpay"
    static let masterPreferences = "api/master/preferences"
    static let questionDetail = "api/ask-question-detail"
    static let apptDetail = "api/request-detail"
    static let payExtra = "api/pay-extra-payment"
    static let notifyUser = "api/notify-user"
    static let addBank = "api/add-bank"
    static let banks = "api/bank-accounts"
    static let sendEmailOTP = "api/send-email-otp"
    static let verifyEmail = "api/email-verify"
    static let getMedicalHistory = "api/get-medical-history"
    
    
    #if CloudDoc
    static let subscriptions = "api/subscriptions"
    static let packageDetail = "api/subscription-detail"
    static let buyPackage = "api/subscription-pack"
    static let addCarePlan = "api/care-plans"
    #elseif NurseLynx
    static let addCarePlan = "api/care-plans"
    static let tiers = "api/tiers"
    static let packageDetail = "api/pack-detail"
    static let buyPackage = "api/sub-pack"
    #else
    static let packageDetail = "api/pack-detail"
    static let buyPackage = "api/sub-pack"
    #endif
    //Chat
    static let chatListing = "api/chat-listing"
    static let chatMessages = "api/chat-messages"
    static let endChat = "api/complete-chat"
    
    static let termsConditions = "terms-conditions"
    static let privacyPolicy = "privacy-policy"
    static let salesAgreement = "sales-agreement"
    
    static let vendorListV2 = "api/v2/doctor-list"
    static let createRequestV2 = "api/v2/create-request"
    static let confirmRequestV2 = "api/v2/confirm-request"
}

