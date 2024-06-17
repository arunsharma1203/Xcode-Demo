//
//  LessonStoreData.swift
//  Xcode Demo
//
//  Created by Arun Sharma on 16/06/24.
//

import Foundation
import SwiftUI
class NetworkManager: ObservableObject {
    @Published var products: [Product] = []

    private let productsURL = "https://fakestoreapi.com/products"

    init() {
        loadProducts()
    }

    func loadProducts() {
        // Check if data is stored locally
        if let savedProducts = UserDefaults.standard.object(forKey: "products") as? Data {
            let decoder = JSONDecoder()
            if let loadedProducts = try? decoder.decode([Product].self, from: savedProducts) {
                self.products = loadedProducts
                return
            }
        }

        // Fetch data from the API if not stored locally
        guard let url = URL(string: productsURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let products = try? decoder.decode([Product].self, from: data) {
                    DispatchQueue.main.async {
                        self.products = products
                        self.saveProducts(products)
                    }
                }
            }
        }.resume()
    }

    func saveProducts(_ products: [Product]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(products) {
            UserDefaults.standard.set(encoded, forKey: "products")
        }
    }
}
struct LessonStoreData: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(networkManager.products) { product in
                        VStack(alignment: .leading) {
                            Text(product.title)
                                .font(.headline)
                            Text(String(format: "$%.2f", product.price))
                                .foregroundColor(.secondary)
                            Text(product.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Products")
        }
        .onAppear {
            networkManager.loadProducts()
        }
    }
}

#Preview {
    LessonStoreData()
}
