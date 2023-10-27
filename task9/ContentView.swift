//
//  ContentView.swift
//  task9
//
//  Created by Роман on 25/10/2023.
//

import SwiftUI


fileprivate enum ResolveType: Int {
    case onBackGround
    case onForeground
}

struct ContentView: View {
    private let centerWidth = UIScreen.main.bounds.width / 2
    private let centerHeight = UIScreen.main.bounds.height / 2
    
    private var width: Double {
        return (UIScreen.main.bounds.width / 5)
    }
    
    private var cicle: some View = Circle()
                                .frame(width: UIScreen.main.bounds.width / 5)
                                .aspectRatio(1, contentMode: .fit)
    
    @State private var position: CGSize = .zero
    
    var body: some View {
        Canvas { context, size in
            guard let firstCircle = context.resolveSymbol(id: ResolveType.onForeground.rawValue),
                  let secondCircle = context.resolveSymbol(id: ResolveType.onBackGround.rawValue) else {
                return
            }
            context.addFilter(.alphaThreshold(min: 0.2, max: 0.6, color: .green))
            context.addFilter(.blur(radius: firstCircle.size.width / 2))
            context.drawLayer { contextSecond in
                contextSecond.draw(firstCircle, at: .init(x: centerWidth, y: centerHeight))
                contextSecond.draw(secondCircle, at: .init(x: centerWidth, y: centerHeight))
            }
        } symbols: {
            cicle.offset(x: position.width, y: position.height).tag(ResolveType.onForeground.rawValue)
            cicle.tag(ResolveType.onBackGround.rawValue)
        }.background()
            .draggable(position: $position)
            .animation(.interactiveSpring(dampingFraction: 0.4, blendDuration: 1), value: self.position)
    }
}

struct DraggableView: ViewModifier {
    @Binding var position: CGSize
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    position = value.translation
                }
                .onEnded({ value in
                    position = .zero
                })
            )
    }
}

extension View {
    func draggable(position: Binding<CGSize>) -> some View {
        return modifier(DraggableView(position: position))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
