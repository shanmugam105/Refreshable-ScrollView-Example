//
//  RefreshableScrollViewView.swift
//  Refreshable-ScrollView-Example
//
//  Created by Mac on 06/07/22.
//

import SwiftUI

struct RefreshableScrollViewView<T: View>: View {
    @State private var refresh: Refresh = .init(started: false, released: false)
    var contentView: T
    var onRefresh: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                GeometryReader { reader -> AnyView in
                    DispatchQueue.main.async { [self] in
                        if refresh.startOffset == 0 {
                            refresh.startOffset = reader.frame(in: .global).minY
                        }
                        
                        refresh.offset = reader.frame(in: .global).minY
                        
                        if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                            refresh.started = true
                        }
                        
                        if refresh.startOffset == refresh.offset, refresh.started, !refresh.released {
                            withAnimation { refresh.released = true }
                            updateData()
                        }
                        
                        if refresh.startOffset == refresh.offset, refresh.started, refresh.released, refresh.invalid {
                            refresh.invalid = false
                            updateData()
                        }
                    }
                    return AnyView(Color.black.frame(width: 0, height: 0))
                }.frame(width: 0, height: 0)
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    if refresh.released, refresh.started {
                        ProgressView().offset(y: -35)
                    } else {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 16, weight: .heavy))
                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                            .offset(y: -25)
                            .animation(.easeIn)
                    }
                    // This is out main content
                    contentView
                }
                .offset(y: refresh.released ? 40 : 0)
            }
        }
    }
    
    private func updateData() {
        onRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.linear) {
                if refresh.startOffset == refresh.offset {
                    refresh.released = false
                    refresh.started = false
                } else {
                    refresh.invalid = true
                }
            }
        }
    }
}

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var started: Bool
    var released: Bool
    var invalid: Bool = false
}
