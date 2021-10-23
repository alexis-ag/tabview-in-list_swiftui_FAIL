import SwiftUI
import Combine
import PagerTabStripView

extension ProfileDetailsView {
    class VM: ObservableObject {
        init() {
            bind()
        }
        private var pipelines: Set<AnyCancellable> = []

        let firstTabRowHeight: CGFloat = 50
        let secondTabRowHeight: CGFloat = 70
        let thirdTabRowHeight: CGFloat = 90

        @Published var firstTabItems = 1...20
        @Published var secondTabItems = 1...50
        @Published var thirdTabItems = 1...100
        @Published var selectedTab: Tab = .first
        @Published var tabHeight: CGFloat = 0

        func bind() {
            $selectedTab
                    .map { self.mapToSize($0) }
                    .assign(to: &$tabHeight)
        }

        private func mapToSize(_ tab: Tab) -> CGFloat {
            switch tab {
            case .first:
                return 200
            case .second:
                return 800
            case .third:
                return 1600
            }
        }
    }
}

extension ProfileDetailsView {
    enum Tab: String, Identifiable {
        var id: String { self.rawValue }
        case first = "first"
        case second = "second"
        case third = "third"
    }
}

struct ProfileDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var vm: VM = .init()

    var body: some View {
        ZStack(alignment: .top) {
            content
            headerButtons
        }
                .ignoresSafeArea(edges: .bottom)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
    }

    private var content: some View {
        List {
            info
            //tabs
            tabs2
        }
                .listStyle(.plain)
                .background(Color.green.opacity(0.1))
    }

    @ViewBuilder
    private var info: some View {
        Group {
            headerImage
            infoFields
        }
    }

    private var headerImage: some View {
        Image("profile-img")
                .resizable()
                .aspectRatio(contentMode: .fit)
    }

    private var headerButtons: some View {
        HStack {
            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                Text("Back")
                    .foregroundColor(.accentColor)
            }
            Spacer()
            Button(action: { print("Edit") }) {
                Text("Edit")
                        .foregroundColor(.accentColor)
            }
        }
                .ignoresSafeArea()
                .padding()

    }

    private var infoFields: some View {
        Group {
            Text("Info 1")
            Text("Info 2")
            Text("Info 3")
        }
    }

    private var tabs: some View {
        PagerTabStripView() {
            firstTab
                    .pagerTabItem {
                        TitleNavBarItem(title: "Tab 1")
                    }
            secondTab
                    .pagerTabItem {
                        TitleNavBarItem(title: "Tab 2")
                    }
            firstTab
                    .pagerTabItem {
                        TitleNavBarItem(title: "Tab 3")
                    }
        }
    }

    private var tabs2: some View {
        Section(header: customTabs) {
            TabView(selection: $vm.selectedTab) {
                firstTab
                        .tag(Tab.first)
                secondTab
                        .tag(Tab.second)
                thirdTab
                        .tag(Tab.third)
            }.tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: vm.tabHeight)
        }
     }

    private var customTabs: some View {
        Picker("", selection: $vm.selectedTab) {
            Text("First").tag(Tab.first)
            Text("Second").tag(Tab.second)
            Text("Third").tag(Tab.third)
        }.pickerStyle(.segmented)
    }

    private var firstTab: some View {
        VStack {
            ForEach(vm.firstTabItems, id: \.self) { i in
                VStack {
                    Text("First tab: \(i)")
                    Divider()
                }
            }
        }
    }

    private var secondTab: some View {
        VStack {
            ForEach(vm.secondTabItems, id: \.self) { i in
                VStack {
                    Text("Second tab: \(i)")
                    Divider()
                }
            }
        }
    }

    private var thirdTab: some View {
        VStack {
            ForEach(vm.thirdTabItems, id: \.self) { i in
                VStack {
                    Text("Third tab: \(i)")
                    Divider()
                }
            }
        }
    }
}

struct TitleNavBarItem: View {
    let title: String

    var body: some View {
        VStack {
            Text(title)
                    .foregroundColor(Color.gray)
                    .font(.subheadline)
        }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
    }
}