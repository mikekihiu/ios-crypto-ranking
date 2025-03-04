//
//  Coin.swift
//  CoinRanking
//
//  Created by Mike Kihiu on 03/03/2025.
//
import SwiftUI

@Observable
class Coin: Decodable {
    let uuid, name, color, iconUrl, price, dailyVolume, marketCap: String
    let rank, tier: Int
    let listedAt: Double
    let sparkline: [String]
    var isFavorite = false
    
    var pngUrl: String {
        iconUrl.replacingOccurrences(of: ".svg", with: ".png")
    }
    
    var doublePrice: Double {
        Double(price) ?? 0
    }
    
    init(uuid: String, name: String, color: String, iconUrl: String, price: String, dailyVolume: String, marketCap: String, rank: Int, tier: Int, listedAt: Double, sparkline: [String], isFavorite: Bool = false) {
        self.uuid = uuid
        self.name = name
        self.color = color
        self.iconUrl = iconUrl
        self.price = price
        self.dailyVolume = dailyVolume
        self.marketCap = marketCap
        self.rank = rank
        self.tier = tier
        self.listedAt = listedAt
        self.sparkline = sparkline
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid, name, color, iconUrl, price, rank, sparkline, marketCap, tier, listedAt
        case dailyVolume = "24hVolume"
    }
}

extension Coin: Identifiable {
    var id: String {
        uuid
    }
}


let previewCoin = Coin(
    uuid: "some-uuid",
    name: "Bitcoin",
    color: "#f7931A",
    iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.png",
    price: "93232.03524011733",
    dailyVolume: "29977895317",
    marketCap: "1819190353464",
    rank: 1,
    tier: 1,
    listedAt: 1330214400,
    sparkline: [
        "85937.97724792948",
        "85918.44905355245",
        "86101.36397346397",
        "85942.83987964696",
        "85787.90713650442",
        "85462.47826927176",
        "86420.04090726929",
        "89442.02185277283",
        "92759.53734417532",
        "93364.71226165233",
        "93175.24213028401",
        "93980.8499939721",
        "94051.31854618045",
        "94259.72413944946",
        "94428.27077248092",
        "93790.21905326378",
        "93032.10110023936",
        "92968.86715956812",
        "92848.51455968965",
        "92753.69615857609",
        "93077.60674514432",
        "92642.63026046957",
        "91970.47839326762",
        "91968.14939929661"
    ]
)

struct CoinResponse: Decodable {
    let status: String
    let data: CoinData
    
    var isSuccess: Bool {
        status.compare("success", options: [.caseInsensitive]) == .orderedSame
    }
}

struct CoinData: Decodable {
    let coins: [Coin]
}

struct SparkLine: Identifiable {
    let id: Int
    let value: Double
}

extension Coin {
    
    var graph: [SparkLine] {
        sparkline
            .compactMap { str in Double(str) }
            .enumerated()
            .map { offset, value in
            .init(id: offset, value: value)
        }
    }
}
