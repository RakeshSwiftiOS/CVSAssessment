//
//  FlickrSearchViewModel.swift
//  SearchImagesOnFlickrAPI
//
//  Created by Rakesh on 7/12/24.
//

import Foundation
import Combine

class FlickrSearchViewModel: ObservableObject {
    private let network: Network
    private var subs = Set<AnyCancellable>()
    private var timer: Timer?
    
    @Published var items: [FlickrImage] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var searchQuery: String = "" {
        didSet {
            guard !searchQuery.isEmpty else {
                items = []
                invalidateTimer()
                return
            }
            invalidateTimer()
            isLoading = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] _ in
                self?.fetch()
            })
        }
    }
    
    init(network: Network = NetworkService()) {
        self.network = network
    }
    
    private func fetch() {
        network.fetchData(with: Environment.search(searchQuery).request)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                print(completion)
                switch completion {
                case .failure:
                    self?.hasError = true
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] (model: FlickrWrapper) in
                self?.items = model.items
            }.store(in: &subs)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
        isLoading = false
    }
}

