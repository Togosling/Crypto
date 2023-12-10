//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Тагай Абдылдаев on 2023/12/9.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var saveEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed loading Core Data \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: - Public
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = saveEntities.first(where: {$0.coinId == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - Private
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Entities \(error.localizedDescription)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving entity \(error.localizedDescription)")
        }
    }
    
    func applyChanges() {
        save()
        getPortfolio()
    }
}
