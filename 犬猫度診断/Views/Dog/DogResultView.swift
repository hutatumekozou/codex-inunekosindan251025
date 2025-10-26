import SwiftUI

struct DogResultView: View {
    let total: Int
    let type: DogType
    let template: DogResultTemplate
    var onClose: () -> Void = {}

    private var percent: Int {
        let clamped = max(20, min(80, total))
        let normalized = Double(clamped - 20) / 60.0 * 100.0
        return Int(round(normalized))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 8)

                (Image.dc_fromAssets("dc_result_dog_default") ?? Image(systemName: "pawprint.fill"))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .foregroundColor(Color.orange)
                    .padding(.bottom, 8)

                Text(template.title)
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(template.subtitle)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 16) {
                    Label("\(percent)%", systemImage: "pawprint.fill")
                        .font(.title2.bold())
                        .monospacedDigit()
                    Divider()
                    Text("合計 \(total) / 80")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(UIColor.secondarySystemBackground))
                )

                VStack(alignment: .leading, spacing: 14) {
                    Text("診断結果")
                        .font(.title3.weight(.semibold))
                    Text(template.description)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    Text("相性のヒント")
                        .font(.title3.weight(.semibold))
                    Text(template.tips)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: Color.black.opacity(0.05), radius: 12, y: 8)
                )

                Button {
                    onClose()
                } label: {
                    Label("HOMEに戻る", systemImage: "house.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 32)
                        .background(
                            Capsule()
                                .fill(Color(#colorLiteral(red: 0.0, green: 0.42, blue: 1.0, alpha: 1)))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(24)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}
