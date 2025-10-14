//
//  MonarchAIChatView.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import SwiftUI

// MARK: - Theme

private enum MonarchTheme {
    static let accent = Color.orange
    static let accentSoft = Color.orange.opacity(0.18)
    static let userBubble = Color.accentColor.opacity(0.16)
    static let assistantBubble = accentSoft
    static let bg = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let border = Color.black.opacity(0.08)

    // Gradients
    static let headerGradient = LinearGradient(
        colors: [
            Color.orange.opacity(0.28),
            Color.pink.opacity(0.22),
            Color.clear
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - ContentView

struct MonarchAIChatView: View {
    @StateObject private var ai = MonarchAI()
    @StateObject private var speech = SpeechManager()
    @StateObject private var tts = TTSManager()

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State private var userInput: String = ""
    @State private var isImmersed = false
    @State private var useTTS = true

    // Auto-scroll helpers
    @State private var scrollToBottomTrigger = UUID()

    var body: some View {
        NavigationStack {
            ZStack {
                MonarchTheme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBar
                    Divider().opacity(0.08)
                    chatList
                        .overlay(alignment: .bottomTrailing) { jumpToBottomButton }
                        .background(
                            MonarchTheme.headerGradient
                                .blur(radius: 36)
                                .opacity(0.45)
                                .ignoresSafeArea(edges: .top)
                        )
                        .onChange(of: ai.messages.count) { _, _ in bumpScroll() }
                        .onChange(of: ai.isStreaming) { _, _ in bumpScroll(delay: 0.05) }
                        .onChange(of: scrollToBottomTrigger) { _, _ in /* just a trigger */ }

                    Spacer(minLength: 8)
                    composer
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .padding(.top, 6)
                        .background(.thinMaterial)
                        .overlay(Divider().opacity(0.05), alignment: .top)
                }
            }
            .navigationTitle("")
            .toolbar(.hidden)
            .task { await ai.prepareIfNeeded() }
            .onChange(of: ai.lastReplyText) { _, reply in
                guard useTTS, let reply else { return }
                tts.speak(reply)
            }
            .onChange(of: speech.transcript) { _, new in
                userInput = new
            }
        }
    }

    // MARK: Header

    private var headerBar: some View {
        HStack(spacing: 12) {
            // Fallback symbol for visionOS if "butterfly" isn’t available
            let symbolName = UIImage(systemName: "butterfly") != nil ? "butterfly" : "leaf"

            ZStack {
                Circle().fill(MonarchTheme.accent.opacity(0.20))
                Image(systemName: symbolName)
                    .imageScale(.large)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.primary)
            }
            .frame(width: 36, height: 36)
            .overlay(Circle().stroke(MonarchTheme.border))

            VStack(alignment: .leading, spacing: 2) {
                Text("VivaMonarchAI")
                    .font(.title3.weight(.semibold))
                HStack(spacing: 8) {
                    availabilityPill
                    if ai.isStreaming {
                        TypingDots(size: 4, spacing: 3)
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("Generating…")
                    }
                }
            }
            Spacer()
//            Toggle(isOn: $useTTS) {
//                Image(systemName: useTTS ? "speaker.wave.2.fill" : "speaker.slash")
//            }
//            .toggleStyle(.switch)
//            .help("Toggle spoken replies")
//
//            Button(action: toggleImmersive) {
//                Image(systemName: isImmersed ? "xmark.circle" : "view.3d")
//                    .imageScale(.large)
//            }
//            .buttonStyle(.borderedProminent)
//            .help(isImmersed ? "Exit immersive space" : "Enter immersive space")
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    private var availabilityPill: some View {
        let text = ai.availabilityDescription
        return Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(MonarchTheme.surface)
                    .overlay(Capsule().stroke(MonarchTheme.border))
            )
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }

    // MARK: Chat List

    private var chatList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(ai.messages) { msg in
                        MessageRow(message: msg)
                            .id(msg.id)
                            .padding(.horizontal, 16)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = msg.text
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                            }
                            .onTapGesture(count: 2) { // quick copy
                                UIPasteboard.general.string = msg.text
                            }
                    }

                    if ai.isStreaming {
                        HStack(spacing: 8) {
                            TypingDots()
                            Text("Thinking like a butterfly…")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .transition(.opacity)
                    }

                    // Bottom spacer to prevent composer overlap
                    Spacer(minLength: 60)
                        .id("BottomSpacer")
                }
                .padding(.vertical, 14)
            }
            .background(MonarchTheme.bg)
            .onChange(of: ai.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.22)) {
                    proxy.scrollTo("BottomSpacer", anchor: .bottom)
                }
            }
            .onChange(of: ai.isStreaming) { _, _ in
                withAnimation(.easeOut(duration: 0.22)) {
                    proxy.scrollTo("BottomSpacer", anchor: .bottom)
                }
            }
            .onChange(of: scrollToBottomTrigger) { _, _ in
                withAnimation(.easeOut(duration: 0.22)) {
                    proxy.scrollTo("BottomSpacer", anchor: .bottom)
                }
            }
        }
    }

    private var jumpToBottomButton: some View {
        Button {
            bumpScroll()
        } label: {
            Image(systemName: "arrow.down.circle.fill")
                .imageScale(.large)
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
        }
        .padding(.bottom, 80)
        .padding(.trailing, 16)
        .opacity(ai.messages.count > 3 ? 1 : 0)
        .animation(.easeOut(duration: 0.2), value: ai.messages.count)
        .accessibilityLabel("Jump to latest")
    }

    private func bumpScroll(delay: Double = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            scrollToBottomTrigger = UUID()
        }
    }

    // MARK: Composer

    private var composer: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                // Speech toggle
                Button {
                    speech.toggle()
                } label: {
                    Image(systemName: speech.isRecording ? "mic.fill" : "mic")
                        .padding(10)
                }
                .buttonStyle(.bordered)
                .help(speech.isRecording ? "Stop listening" : "Start listening")

                // Growing input
                GrowingTextEditor(text: $userInput, placeholder: "Ask the monarch…")
                    .frame(minHeight: 40, maxHeight: 140)
                    .disabled(ai.isBusy)
                    .onSubmit(send)

                // Send
                Button(action: send) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || ai.isBusy)
            }

            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                Text("The butterfly persona is fictional. Don’t take naturalist or medical advice from it.")
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.leading, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(MonarchTheme.border)
                )
                .shadow(color: .black.opacity(0.06), radius: 16, y: 6)
        )
    }

    // MARK: Send & Immersive

    private func send() {
        let text = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        userInput = ""
        Task { await ai.send(userText: text) }
        bumpScroll()
    }

    private func toggleImmersive() {
        Task {
            if isImmersed {
                await dismissImmersiveSpace()
                isImmersed = false
            } else {
                switch await openImmersiveSpace(id: ImmersiveIDs.monarchSpace) {
                case .opened: isImmersed = true
                case .userCancelled, .error: isImmersed = false
                @unknown default: isImmersed = false
                }
            }
        }
    }
}

// MARK: - Message Row

private struct MessageRow: View {
    let message: ChatMessage

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if isUser { Spacer(minLength: 30) }

            VStack(alignment: .leading, spacing: 6) {
                Text(message.text)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(bubbleBackground)
                    .overlay(bubbleBorder)
                    .clipShape(BubbleShape(isUser: isUser))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 3)

                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 6)
            }

            if !isUser { Spacer(minLength: 30) }
        }
        .transition(.asymmetric(
            insertion: .move(edge: isUser ? .trailing : .leading).combined(with: .opacity),
            removal: .opacity
        ))
    }

    private var bubbleBackground: some ShapeStyle {
        (isUser ? MonarchTheme.userBubble : MonarchTheme.assistantBubble)
            .gradient
    }

    private var bubbleBorder: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .inset(by: 0.25)
            .stroke(MonarchTheme.border, lineWidth: 0.5)
    }
}

// Bubble with “tail” subtly offset
private struct BubbleShape: Shape {
    var isUser: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path(roundedRect: rect, cornerRadius: 18, style: .continuous)
        // tiny tail notch
        let tailWidth: CGFloat = 8
        let tailHeight: CGFloat = 8
        let y = rect.maxY - 10
        let x = isUser ? rect.maxX : rect.minX
        var tail = Path()
        if isUser {
            tail.move(to: CGPoint(x: x, y: y))
            tail.addLine(to: CGPoint(x: x + tailWidth, y: y - tailHeight))
            tail.addLine(to: CGPoint(x: x, y: y - 2))
        } else {
            tail.move(to: CGPoint(x: x, y: y))
            tail.addLine(to: CGPoint(x: x - tailWidth, y: y - tailHeight))
            tail.addLine(to: CGPoint(x: x, y: y - 2))
        }
        path.addPath(tail)
        return path
    }
}

// MARK: - Typing Dots

private struct TypingDots: View {
    var size: CGFloat = 6
    var spacing: CGFloat = 4
    @State private var phase: CGFloat = 0

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<3) { i in
                Circle()
                    .frame(width: size, height: size)
                    .offset(y: sin(phase + CGFloat(i) * 0.6) * 3)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: phase)
            }
        }
        .onAppear { phase = .pi / 2 }
    }
}

// MARK: - Growing TextEditor

private struct GrowingTextEditor: View {
    @Binding var text: String
    let placeholder: String

    @State private var dynamicHeight: CGFloat = 40

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
            }

            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
                .background(Color.clear)
                .onAppear { recalcHeight() }
                .onChange(of: text) { _, _ in recalcHeight() }
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.tertiarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(MonarchTheme.border)
        )
    }

    private func recalcHeight() {
        // Rough but effective line-height estimate for body font
        let lines = max(1, min(5, text.split(separator: "\n").count + (text.count > 0 ? Int(Double(text.count) / 26.0) : 0)))
        dynamicHeight = CGFloat(22 * lines + 10)
    }
}
