//
//  ContentView.swift
//  counter
//
//  Created by しょう on 2026/02/08.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    // 触覚フィードバックの準備
    let impactMed = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.95, green: 0.95, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Counter")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)

                // カウント表示部分
                Text("\(count)")
                    .font(.system(size: 120, weight: .heavy, design: .monospaced))
                    .foregroundColor(count >= 0 ? .primary : .red)
                    .contentTransition(.numericText())
                    .animation(.spring(), value: count)

                HStack(spacing: 30) {
                    // 減らすボタン
                    CounterButton(symbol: "minus", color: .red) {
                        count -= 1
                        triggerHaptic()
                    }

                    // リセットボタン
                    Button(action: {
                        count = 0
                        triggerHaptic()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .padding()
                            .background(Circle().fill(Color.white).shadow(radius: 2))
                    }

                    // 増やすボタン
                    CounterButton(symbol: "plus", color: .green) {
                        count += 1
                        triggerHaptic()
                    }
                }
            }
        }
    }

    // 振動させる関数
    func triggerHaptic() {
        impactMed.impactOccurred()
    }
}

// カスタムボタンコンポーネント
struct CounterButton: View {
    let symbol: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(color.gradient)
                .cornerRadius(25)
                .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// 押した時に少し小さくなるエフェクト
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
