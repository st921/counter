//
//  ContentView.swift
//  counter
//
//  Created by しょう on 2026/02/08.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    // 背景色の計算
    private var backgroundColor: Color {
        if count > 0 { return Color.green.opacity(0.05) }
        if count < 0 { return Color.red.opacity(0.05) }
        return Color(red: 0.95, green: 0.95, blue: 0.97)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .animation(.default, value: count)

            VStack(spacing: 40) {
                Text("Smart Counter")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(2)

                Text("\(count)")
                    .font(.system(size: 120, weight: .black, design: .monospaced))
                    .foregroundColor(count == 0 ? .primary : (count > 0 ? .green : .red))
                    .contentTransition(.numericText(value: Double(count)))
                    .animation(.spring(response: 0.35, dampingFraction: 0.6), value: count)

                HStack(spacing: 25) {
                    // 減らす
                    CounterButtonV2(symbol: "minus", color: .red) {
                        count -= 1
                    }

                    // リセットボタン（.success に修正）
                    Button(action: { count = 0 }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.white).shadow(color: .black.opacity(0.1), radius: 5))
                    }
                    .sensoryFeedback(.success, trigger: count == 0) // ここを修正

                    // 増やす
                    CounterButtonV2(symbol: "plus", color: .green) {
                        count += 1
                    }
                }
            }
        }
    }
}

// 改良版ボタン：長押し対応とフィードバックの統合
struct CounterButtonV2: View {
    let symbol: String
    let color: Color
    let action: () -> Void
    
    @GestureState private var isPressing = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(color.gradient)
                .cornerRadius(28)
                .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(ScaleButtonStyle())
        // 押すたびに軽い衝撃
        .sensoryFeedback(.impact(weight: .light), trigger: isPressing)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
#Preview{
    ContentView()
}
