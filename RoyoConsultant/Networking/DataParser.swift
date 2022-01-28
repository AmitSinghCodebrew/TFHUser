//
//  DataParser.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import Foundation
import Moya

extension TargetType {
    
    func parseModel(data: Data) -> Any? {
        switch self {
        //EP_Login Endpoint
        case is EP_Login:
            let endpoint = self as! EP_Login
            switch endpoint {
            case .login,
                 .profileUpdate,
                 .register,
                 .updatePhone(_, _, _),
                 .updateInsuranceAndAddress,
                 .locationUpdate:
                let response = JSONHelper<CommonModel<User>>().getCodableModel(data: data)?.data
                UserPreference.shared.data = response
                return response
            default:
                return nil
            }
        case is EP_Home:
            let endPoint = self as! EP_Home
            switch endPoint {
            case .categories:
                return JSONHelper<CommonModel<CategoryData>>().getCodableModel(data: data)?.data
            case .requests,
                 .apptDetail:
                return JSONHelper<CommonModel<RequestData>>().getCodableModel(data: data)?.data
            case .logout:
                UserPreference.shared.data = nil
                return nil
            case .vendorList:
                return JSONHelper<CommonModel<VendorData>>().getCodableModel(data: data)?.data
            case .vendorDetail(_):
                return JSONHelper<CommonModel<VendorDetailData>>().getCodableModel(data: data)?.data?.vendor_data
            case .banners:
                return JSONHelper<CommonModel<BannersData>>().getCodableModel(data: data)?.data
            case .chatListing(_):
                return JSONHelper<CommonModel<ChatData>>().getCodableModel(data: data)?.data
            case .chatMessages(_, _):
                return JSONHelper<CommonModel<MessagesData>>().getCodableModel(data: data)?.data
            case .uploadImage:
                return JSONHelper<CommonModel<ImageUploadData>>().getCodableModel(data: data)?.data
            case .transactionHistory(_, _):
                return JSONHelper<CommonModel<TransactionData>>().getCodableModel(data: data)?.data
            case .wallet:
                return JSONHelper<CommonModel<WalletBalance>>().getCodableModel(data: data)?.data
            case .addCard(_, _, _, _),
                 .cards:
                return JSONHelper<CommonModel<CardsData>>().getCodableModel(data: data)?.data
            case .createRequest:
                return JSONHelper<CommonModel<CreateRequestData>>().getCodableModel(data: data)?.data
            case .notifications(_):
                return JSONHelper<CommonModel<NotificationData>>().getCodableModel(data: data)?.data
            case .classes(_, _, _, _):
                return JSONHelper<CommonModel<ClassesData>>().getCodableModel(data: data)?.data
            case .services(_):
                return JSONHelper<CommonModel<ServicesData>>().getCodableModel(data: data)?.data
            case .getFilters(_):
                return JSONHelper<CommonModel<FilterData>>().getCodableModel(data: data)?.data
            case .getReviews(_, _):
                return JSONHelper<CommonModel<ReviewsData>>().getCodableModel(data: data)?.data
            case .coupons(_, _):
                return JSONHelper<CommonModel<CouponsData>>().getCodableModel(data: data)?.data
            case .confirmRequest:
                return JSONHelper<CommonModel<ConfirmBookingData>>().getCodableModel(data: data)?.data
            case .getSlots(_, _, _, _):
                return JSONHelper<CommonModel<SlotsData>>().getCodableModel(data: data)?.data
            case .appversion(_, _):
                let obj = JSONHelper<CommonModel<AppData>>().getCodableModel(data: data)?.data
                return obj
            case .getClientDetail(_):
                let obj = JSONHelper<CommonModel<ClientDetail>>().getCodableModel(data: data)?.data
                //obj?.invite_enabled = true
                UserPreference.shared.clientDetail = obj
                return obj
            case .addMoney(_, _):
                return JSONHelper<CommonModel<StripeData>>().getCodableModel(data: data)?.data
            case .pages:
                return JSONHelper<CommonModel<PagesData>>().getCodableModel(data: data)?.data?.pages
            case .getCountryStateCity(_, _, _):
                return JSONHelper<CommonModel<CountryStateCityData>>().getCodableModel(data: data)?.data
            case .packages(_, _, _, _),
                 .packageDetail(_),
                 .buyPackage(_):
                return JSONHelper<CommonModel<PackagesData>>().getCodableModel(data: data)?.data
            case .getFeeds(_, _, _),
                 .viewFeed(_):
                return JSONHelper<CommonModel<FeedsData>>().getCodableModel(data: data)?.data
            case .home:
                return JSONHelper<CommonModel<HomeData>>().getCodableModel(data: data)?.data
            case .getComments(_):
                return JSONHelper<CommonModel<CommentData>>().getCodableModel(data: data)?.data
            case .addComment(_, _):
                return JSONHelper<CommonModel<CommentData>>().getCodableModel(data: data)?.data?.comment
            case .getQuestions, .submitQuestion, .questionDetail:
                return JSONHelper<CommonModel<QuestionsData>>().getCodableModel(data: data)?.data
            case .orderCreate:
                return JSONHelper<CommonModel<Order>>().getCodableModel(data: data)?.data
            case .supportPackages:
                return JSONHelper<CommonModel<PackagesData>>().getCodableModel(data: data)?.data
            case .symptoms:
                return JSONHelper<CommonModel<SymptomsData>>().getCodableModel(data: data)?.data
            case .addWaterLimit, .getWaterLimit, .drinkWater:
                return JSONHelper<CommonModel<WaterIntakeData>>().getCodableModel(data: data)?.data
            case .addProteinLimit, .getProteinLimit, .drinkProtein:
                return JSONHelper<CommonModel<WaterIntakeData>>().getCodableModel(data: data)?.data
            case .addFamily:
                return JSONHelper<CommonModel<FamilyData>>().getCodableModel(data: data)?.data?.family
            case .masterPreferences(_):
                let prefs = JSONHelper<CommonModel<MasterPreferences>>().getCodableModel(data: data)?.data?.preferences
                UserPreference.shared.masterPrefs = prefs
                return prefs
            case .getMedicalHistory:
                return JSONHelper<CommonModel<MedicalHistoryData>>().getCodableModel(data: data)?.data
            case .banks:
                return JSONHelper<CommonModel<BanksData>>().getCodableModel(data: data)?.data
            case .payExtra:
                return JSONHelper<CommonModel<CreateRequestData>>().getCodableModel(data: data)?.data
            #if CloudDoc
            case .subscriptions:
                return JSONHelper<CommonModel<PackagesData>>().getCodableModel(data: data)?.data
            #elseif NurseLynx
            case .tiers:
                return JSONHelper<CommonModel<TiersData>>().getCodableModel(data: data)?.data
            #endif
            default:
                return nil
            }
        case is EP_Others:
            let endPoint = self as! EP_Others
            switch endPoint {
            
            case .vendorListV2:
                return JSONHelper<CommonModel<VendorData>>().getCodableModel(data: data)?.data
            case .createRequest:
                return JSONHelper<CommonModel<CreateRequestData>>().getCodableModel(data: data)?.data
            case .confirmRequest:
                return JSONHelper<CommonModel<ConfirmBookingData>>().getCodableModel(data: data)?.data

            }
        default:
            return nil
        }
    }
}
