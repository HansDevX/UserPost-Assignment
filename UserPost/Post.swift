//
//  Post.swift
//  UserPost
//
//  Created by Kavindu Hansajith on 2024-10-08.
//


import Foundation

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}
