//
//  VCLiterals.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

enum VCLiteral: String {
    case FACEBOOK
    case GOOGLE
    case LOGIN_USING_EMAIL
    case LOGIN_USING_MOBILE
    case SIGNUP_USING_EMAIL
    case NEW_USER
    case SIGNUP
    case LOGIN_EMAIL_DESC
    case EMAIL_PLACEHOLDER
    case LOGIN_WITH
    case PSW_PLACEHOLDER
    case FORGOT_PASSWORD
    case NO_ACCOUNT
    case MOBILE_PACEHOLDER
    case LOGIN_USING_MOBILE_DESC
    case NAME_PLACEHOLDER
    case DOB_PLACEHOLDER
    case DOB
    case ReEnterPsw_PLACEHOLDER
    case BIO_PLACEHOLDER
    case ALREADY_REGISTER
    case LOGIN
    case BY_SIGNING_UP
    case TERMS
    case AND
    case PRIVACY
    case VERIFICATION
    case CODESENT
    case CODE_NOT_RECEIVED
    case RESEND_CODE
    case HOME
    case APPOINTMENTS
    case CHATS
    case VERSION
    case VERSION_INFO
    case HISTORY
    case NOTIFICATIONS
    case INVITE_PEOPLE
    case CONTACT_US
    case TERMS_AND_CONDITIONS
    case ABOUT
    case LOGOUT
    case CLASSES
    case WALLET
    case AGE
    case NA
    case MEET
    case WITH_EXPERTS
    case ALL
    case NEW
    case INPROGRESS
    case ACCEPT
    case COMPLETE
    case NO_ANSWER
    case BUSY
    case FAILED
    case SEARCH_FOR
    case YR_EXP
    case YRS_EXP
    case CALL
    case CHAT
    case REVIEW
    case REVIEWS
    case PATIENTS
    case EXPERIECE
    case PHOTO
    case CHAT_THREAD_TIME
    case END_CHAT
    case END_CHAT_MESSAGE
    case CANCEL
    case OK
    case AVAILABLE_BALANCE
    case ADD_MONEY
    case TRANSACTION_HISTORY
    case MONEY_SENT_TO
    case ADDED_TO_WALLET
    case INPUT_AMOUNT
    case RETRY
    case DEBIT_CARD
    case CREDIT_CARD
    case GPAY
    case BHIM
    case PAY_AMOUNT
    case SCHEDULE
    case REQUEST_SENT_SUCCESS
    case WALLET_ALERT
    case WALLET_ALERT_MESSAGE
    case PROFILE
    case LOGOUT_ALERT_MESSAGE
    case CANCELLED
    case RESCHEDULE
    case BOOKAGAIN
    case CANT_SEND_MESSAGE
    case FILTERS
    case APPLY
    case RATE
    case SUBMIT
    case APPOINTMENT_REVIEW
    case REVIEW_PLACEHOLDER
    case CARD_ENDING_WITH
    case EDIT
    case DELETE
    case DELETE_CARD_MESSAGE
    case EDIT_CARD
    case UPDATE
    case CARD_EXP_PLACEHOLDER
    case CONFIRM_BOOKING
    case BOOKING_DETAILS
    case APPT_DATE_TIME
    case COUPON_PLACEHOLDER
    case PRICE_DETAILS
    case SUB_TOTAL
    case PROMO_APPLIED
    case TOTAL
    case TERMS_CONFIRM_BOOKING
    case PHONE_NUMBER
    case PHONE
    case CHOOSE_DATE_TIME
    case NO_TIME_SLOTS
    case EDIT_SLOT
    case SLOT_FULL_ALERT
    case NO_CLASSES
    case OCCUPY_CLASS
    case OCCUPY_CLASS_ALERT_MESSAGE
    case JOIN_CLASS
    case ACCOUNT_TO_CONTINUE
    case SIGNUP_USING_MOBILE
    case BY_CONTINUE
    case ALREADY_ACCOUNT
    case USE_CODE
    case USERS_REMAINING
    case USER_REMAINING
    case COUPON_TITLE
    case CANCEL_REQUEST
    case CANCEL_REQUEST_ALERT
    case REFUND_FROM
    case NEW_MESSAGE
    case UPLOAD_ERROR
    case EDIT_PROFILE
    case REQUEST_NOW
    case INVALID_AMOUNT
    case NETWORK_ERROR
    case NO_APPOINTMENTS
    case NO_APPOINTMENTS_DESC
    case NO_CHAT
    case NO_CHAT_DESC
    case WALLET_NO_DATA
    case WALLET_NO_DATA_DESC
    case NO_HISTORY
    case NO_HISTORY_DESC
    case NOTIFICATION_NO_DATA
    case NOTIFICATION_NO_DATA_DESC
    case NO_CLASSES_FOR_CATEGORY
    case NO_CLASSES_FOR_CATEGORY_DESC
    case VENDOR_LISTING_NO_DATA
    case VENDOR_LISTING_NO_DATA_DESC
    case FORGOT_PSW_MESSAGE
    case PASSWORD_RESET_MESSAGE
    case APP_DESC
    case START_JOURNEY
    case ADDRESS
    case STATE
    case CITY
    case ZIP
    case DO_YOU_HAVE_INSURANCE
    case IF_YES_WHAT_INSURANCE
    case SELECT_INSURANCE
    case INSURANCE_TERMS_1
    case INSURANCE_TERMS_2
    case INSURANCE_TERMS_3
    case YES
    case NO
    case MINIMUM_INSURANCE_SELECT
    case TERMS_VALIDATION
    case UPDATE_TITLE
    case UPDATE_DESC
    case PACAKAGES
    case CHOOSE_PACKAGE
    case PAY
    case PAY_ALERT_MESSAGE
    case WALLET_ALERT_MESSAGE_PACKAGE
    case ADDED_PACKAGE
    case PACKAGE_NO_DATA
    case PACKAGE_NO_DATA_DESC
    case VIEW_ALL
    case BlOGS
    case ARTICLES
    case LATEST_BLOGS
    case LATEST_ARTICLES
    case GET_STARTED
    case ALLOW_LOCATION
    case ALLOW_LOCATION_DESC
    case USE_MY_LOCATION
    case SKIP_FOR_NOW
    case TIP_OF_THE_DAY
    case CONSULT_ONLINE
    case EMERGENCY_APPT
    case HOME_VISIT
    case FREE_EXPERT_ADVICE
    case CONSULT_DOCTOR
    case HEALTH_TOOL
    case ALL_COMMENTS
    case GENDER
    case HEIGHT
    case WEIGHT
    case KG
    case CM
    case YOUR_BMI
    case MALE
    case FEMALE
    case OVERWEIGHT
    case NORMAL
    case UNDERWEIGHT
    case TRACK_STATUS
    case SERVICE_STARTED
    case REACHED_DEST
    case ON_THE_WAY
    case MY_QUESTIONS
    case ASK
    case ASK_FREE_QUESTIONS
    case QUESTION
    case DESCRIPTION
    case NO_QUESTIONS
    case NO_QUESTIONS_DESC
    case ASK_QUESTION_ALERT
    case ANSWER
    case ANSWERS
    case NO_ANSWER_OF_QUESTION
    case NO_ANSWER_DESC
    case QUESTION_DETAIL_TITLE
    case SKIP
    case ADD_PATIENT
    case GET_ADVICE
    case UPDATE_APPT_TITLE
    case SYMPTOM_DESC_PLACEHOLDER
    case SYMPTOM_DESC_ALERT
    case REPORT_UPLOAD_ALERT
    case SELECT_SYMPTOM_ALERT
    case SECOND_OPINION
    case NEW_OPINION
    case MEDICAL_RECORD
    case RECORD_DETAILS
    case RECORD_TITLE
    case ADD_IMAGES
    case DONE
    case RETRY_SMALL
    case RECORD_TITLE_ALERT
    case PRESCRIPTION_IMAGE_ALERT
    case DOC_UPLOADING_ALERT
    case MILLI_LITRE
    case LITRE
    case SET_DAILY_WATER_LIMIT
    case WATER_INTAKE_IN_LITRES
    case SET_DAILY_LIMIT
    case TESTIMONIALS
    case LOGIN_FOR_HOME_VISIT
    case SELECT_CATEGORY
    case ONLINE_PROGRAMS
    case VIEW_PRESCRIPTION
    case ACCOUNT_SETTINGS
    case CHANGE_PASSWORD
    case CHANGE_LANGUAGE
    case OLD_PSW
    case NEW_PSW
    case CONFIRM_PSW
    case PASSWORD_SUCCESS_MESSAGE
    case ADD_DAILY_WATER_LIMIT
    case ADD_A_PATIENT
    case ELDERELY
    case CHILDREN
    case PRESC_DETAIL
    case PATIENT_SUCCESS
    case ALL_SMALL
    case READ_MORE
    case READ_LESS
    case SYMPTOMS
    case DATE
    case TIME
    case SERVICE_TYPE
    case APPT_DETAIL
    case DOC_MESSAGE
    case AUDIO
    case PROTIEN_INTAKE
    case PROTIEN_GMS
    case TAKE_PROTIEN
    case PROTIEN_INTAKE_IN_GRAMS
    case SET_DAILY_PROTIEN_LIMIT
    case ADD_DAILY_PROTEIN_LIMIT
    case CLINIC_APPT
    case CONSULT_FOR
    case DOC_TITLE
    case HYPER_PAY_TYPE_MADA
    case HYPER_PAY_TYPE_MASTER_VISA
    case ADD
    case INSURANCE_INFO
    case INSURANCE_NUMBER
    case INSURANCE_EXPIRY
    case SAVE
    case INSURANCE_NUMBER_VALUE
    case INSURANCE_EXPIRY_VALUE
    case UPDATE_PHONE_NUMBER
    case CHOOSE_APP_TITLE
    case CHOOSE_APP_OPTION_PATIENT
    case CHOOSE_APP_OPTION_DOCTOR
    case TYPING
    case LANGUAGE_ENGLISH
    case LANGUAGE_ARABIC
    case CHOOSE_LANGUAGE
    case TAB_HOME
    case TAB_APPOINTMENT
    case TAB_CHAT
    case TAB_PROFILE
    case NATIONALITY
    case VIEW_DETAIL
    case NO_ARTICLES
    case NO_ARTICLES_DESC
    case NO_BLOGS
    case NO_BLOGS_DESC
    case DOWNLOAD
    case ADD_ADDRESS
    case SELECT_DELIVERY_ADDRESS
    case CURRENT_LOCATION
    case LOCATION
    case SEND_FEEDBACK
    case CONSULTANTS
    case ASKED_A_QUESTION
    case COMPLETING_PAYMENT
    case PRICE
    case INVITE_CODE
    case USE_REFER_CODE
    case VIEW
    case TAX
    case SUPPORT
    case AMOUNT
    case EXTRA_PAYMENT
    case EXTRA_PAYMENT_STATUS_PENDING
    case EXTRA_PAYMENT_STATUS_PAID
    case PAY_EXTRA
    case EXTRA_PAY_MESSAGE
    case NOTIFY
    case NOTIFY_DESC
    case NOTIFY_MESSAGE
    case FREE_BOOKING_TIME
    case CANCEL_REASON
    case CANCEL_REASON_ALERT
    case BANK_DETAILS
    case BANK_NAME
    case IBAN
    case ESTIMATE_TIME
    case REACHED
    case MEDICAL_HISTORY
    case NO_MEDICAL_HISTORY
    case NO_MEDICAL_HISTORY_DESC
    case DISTANCE_KM
    
    case INTRO_1_TITLE
    case INTRO_2_TITLE
    case INTRO_3_TITLE
    case INTRO_4_TITLE
    case INTRO_5_TITLE
    case INTRO_6_TITLE
    
    case INTRO_1_DESC
    case INTRO_2_DESC
    case INTRO_3_DESC
    case INTRO_4_DESC
    case INTRO_5_DESC
    case INTRO_6_DESC
    
    case success
    case apiFailure
    case validationFailure
    case notification

    case LOC_PERMISSION_DENIED_TITLE
    case LOC_PERMISSION_DENIED_MESSAGE
    
    case HEALTH_TOOL_01_TITLE
    case HEALTH_TOOL_02_TITLE
    case HEALTH_TOOL_03_TITLE
    case HEALTH_TOOL_04_TITLE
    case HEALTH_TOOL_01_SUBTITLE
    case HEALTH_TOOL_02_SUBTITLE
    case HEALTH_TOOL_03_SUBTITLE
    case HEALTH_TOOL_04_SUBTITLE
    
    case FATHER
    case MOTHER
    case GRAND_FATHER
    case GRAND_MOTHER
    case SON
    case DAUGHTER
    case BROTHER
    case SISTER
    case OTHER
    
    case RELATION
    case MEDICAL_ALLERGIES
    case CHRONIC_DISEASE
    case PREVIOUS_SURGERIES
    case PREVIOUS_MEDICATION
    case MEDICATION_NAME
    case CHOOSE_CHRONIC
    
    case CHRONIC_DISEASE_0
    case CHRONIC_DISEASE_1
    case CHRONIC_DISEASE_2
    case CHRONIC_DISEASE_4
    
    case CALCULATION_METHOD
    case LAST_PERIOD
    case CONCEPTION_DATE
    case IVF
    case ULTRASOUND
    case FIRST_DAY_OF_LAST_PERIOD
    case DATE_OF_CONCEPTION
    case DATE_OF_TRANSFER
    case DATE_OF_ULTRSOUND
    case DATE_ONLY_PLACEHOLDER
    case CYCLE_LENGTH
    case IVF_3_DAY
    case IVF_5_DAY
    case ULTRASOUND_WEEKS
    case ULTRASOUND_DAYS
    case IVF_TRANSFER_DATE
    case CALUCLATE_DUE_DATE
    case UltrasoundWeek_One
    case UltrasoundWeek_Two
    case UltrasoundWeek_Three
    case UltrasoundWeek_Four
    case UltrasoundWeek_Five
    case UltrasoundWeek_Six
    case UltrasoundWeek_Seven
    case UltrasoundWeek_Eight
    case UltrasoundWeek_Nine
    case UltrasoundWeek_Ten
    case UltrasoundWeek_Eleven
    case UltrasoundWeek_Twelve
    case UltrasoundWeek_Thirteen
    case UltrasoundWeek_Fourteen
    case UltrasoundWeek_Fifteen
    case UltrasoundWeek_Sixteen
    case UltrasoundWeek_Seventeen
    case UltrasoundWeek_Eighteen
    case UltrasoundWeek_Nineteen
    case UltrasoundWeek_Twenty
    case UltrasoundWeek_TwentyOne
    case UltrasoundWeek_TwentyTwo
    case UltrasoundWeek_TwentyThree
    case UltrasoundWeek_TwentyFour
    case UltrasoundDay_Zero
    case UltrasoundDay_One
    case UltrasoundDay_Two
    case UltrasoundDay_Three
    case UltrasoundDay_Four
    case UltrasoundDay_Five
    case UltrasoundDay_Six
    case CycleLength_NA
    case CycleLength_Days_21
    case CycleLength_Days_22
    case CycleLength_Days_23
    case CycleLength_Days_24
    case CycleLength_Days_25
    case CycleLength_Days_26
    case CycleLength_Days_27
    case CycleLength_Days_28
    case CycleLength_Days_29
    case CycleLength_Days_30
    case CycleLength_Days_31
    case CycleLength_Days_32
    case CycleLength_Days_33
    case CycleLength_Days_34
    case CycleLength_Days_35
    case PREGNANCY_SUCCESS
    case DUE_DATE_IS
    case PREGNANCY_TIMELINE
    case TRIMESTER_1
    case TRIMESTER_2
    case TRIMESTER_3
    case TRIMESTER_VALUE
    case ZODIAC
    case TERMS_ALERT
    case ALERT_NATIONAL_ID

    case aries
    case cancer
    case taurus
    case leo
    case gemini
    case virgo
    case libra
    case capricorn
    case scorpio
    case aquarius
    case sagittarius
    case pisces
    
    #if CloudDoc
    case TOTAL_REQUESTS
    case AVAILABLE_REQUESTS
    case EXPIRING_ON
    case PRE_ASSESMENT
    case HOW_LONG_FELT_THIS_WAY
    case WHAT_WEIGHT
    case WHAT_HEIGHT
    case TAKING_MEDICATION
    case DO_ALLERGIES
    case DO_SMOKE
    case DO_DRINK
    case WEIGHT_WITH_UNIT
    case HEIGHT_WITH_UNIT
    case ANSWER_SHORT
    case IDCARD
    case ID_CARD_ALERT
    #elseif NurseLynx
    case CARE_PLAN
    case PLANS
    case CARE_PLAN_NOTE
    case NeedSomeHelp
    case NeedMuchHelp
    case SALES_CONTRACT
    #endif
    
    case START_DATE_GREATER
    case TIME_GREATER
    case NATIONAL_ID_NUMBER
}

extension VCLiteral {
    var localized: String {
        return NSLocalizedString(self.rawValue, tableName: Configuration.getValue(for: .PROJECT_LOCALIZABLE), comment: "")
    }
}
