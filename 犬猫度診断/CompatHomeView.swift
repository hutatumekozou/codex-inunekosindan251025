import SwiftUI

final class CompatVM: ObservableObject {
    @Published var doc: CompatDoc?
    @Published var pairs: PairProfilesDoc?
    @Published var idx = 0
    @Published var ansA:[String:CompatChoice] = [:]
    @Published var ansB:[String:CompatChoice] = [:]
    @Published var phaseA = true
    func load(qPath: String, rPath: String) {
        doc = CompatRepository.loadCompat(qPath)
        pairs = CompatRepository.loadPairProfiles(rPath)
        idx = 0; ansA = [:]; ansB = [:]; phaseA = true
    }
}

struct CompatHomeView: View {
    @StateObject var vm = CompatVM()
    @State var result: CompatResult?
    var body: some View {
        NavigationView {
            VStack(spacing:16){
                Text("相性診断").font(.largeTitle).bold()
                Button("診断スタート"){
                    vm.load(qPath: "compat_v1.json", rPath: "compat_results.json")
                }.buttonStyle(.borderedProminent)
                if let d = vm.doc, let p = vm.pairs, result == nil {
                    let q = d.questions[vm.idx]
                    Text(vm.phaseA ? "Aさんの回答" : "Bさんの回答").font(.headline)
                    Text("\(vm.idx+1)/\(d.questions.count)").font(.caption).foregroundStyle(.secondary)
                    VStack(alignment:.leading, spacing:12){
                        Text(q.text).font(.title3).bold()
                        ForEach(q.choices, id:\.key){ c in
                            Button(c.text){
                                if vm.phaseA { vm.ansA[q.id] = c } else { vm.ansB[q.id] = c }
                                if vm.idx+1 < d.questions.count { vm.idx += 1 }
                                else {
                                    if vm.phaseA { vm.phaseA=false; vm.idx=0 } // 次はB
                                    else { result = CompatEvaluator.evaluate(ansA: vm.ansA, ansB: vm.ansB, doc: d, pairs: p) }
                                }
                            }
                            .frame(maxWidth:.infinity).padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
                        }
                    }.padding(.horizontal)
                }
                if let r = result {
                    if let img = Image.resolve(r.pairProfile.id) { img.resizable().scaledToFit().frame(maxHeight:220).cornerRadius(12) }
                    Text(r.pairProfile.name).font(.title).bold()
                    Text("相性スコア：\(r.scorePercent)%").font(.headline)
                    Text(r.pairProfile.summary)
                    if let tip = r.pairProfile.tips?.first { Text("今日のヒント：\(tip)") }
                    Button("もう一度"){ result=nil; vm.doc=nil; vm.pairs=nil }
                        .padding(.top,8).buttonStyle(.borderedProminent)
                }
                Spacer()
            }.padding()
        }
    }
}
