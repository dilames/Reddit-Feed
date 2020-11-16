//
//  FeedViewModel.swift
//  Reddit
//
//  Created by Andrew Chersky on 12.11.2020.
//

import Combine
import Foundation
import Platform
import Domain

struct FeedViewModel: ViewModel {
    
    typealias UseCases = HasRedditEndpointUseCase & HasRedditChronoUseCase & HasRedditPicturesUseCase
    
    struct Output {
        let collection: AnyPublisher<[Child], Never>
    }
    
    struct Input {
        let indexPath: AnyPublisher<Int, Never>
    }
    
    struct Handlers {
        let openDetails: PassthroughSubject<(URL, FeedCollectionViewCell), Never>
    }
    
    let handlers: Handlers
    let useCases: UseCases
    
    init(useCases: UseCases, handlers: Handlers) {
        self.useCases = useCases
        self.handlers = handlers
    }
    
    func transform(_ input: Input) -> Output {
        
        let fetchFirstPage = useCases.redditEndpoint.fetchFirstPage()
        
        let fetchNextPage = input.indexPath
            .flatMap { _ in useCases.redditEndpoint.fetchNextPage() }
        
        let collection = Publishers.Merge(fetchFirstPage, fetchNextPage)
            .catch { _ in Empty<[Child], Never>() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return Output(collection: collection)
    }

}
