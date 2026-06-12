import SwiftUI

struct BiblioAgeView: View {
    @Environment(\.dismiss) var dismiss
    
    let idades: [String] = ["4 a 5 ", "6 a 7", "8 a 10"]
    @State private var idadeSelecionada = "4 a 5 "
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 30) {
                    Text("Selecione uma classificação")
                        .font(FontesDoApp.xBold(tamanho: 25))
                        .foregroundColor(.appRoxoTab)
                    
                    Picker("Selecione sua idade", selection: $idadeSelecionada) {
                        ForEach(idades, id: \.self) { idade in
                            Text(idade).tag(idade)
                                .font(.system(size: 20))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss() // Faz a animação de voltar
                }) {
                    HStack(spacing: 10) {
                        Text("Continuar")
                            .font(FontesDoApp.x(tamanho: 16))
                    }
                    .foregroundColor(.white)
                    .frame(width: 320, height: 50)
                    .background(Color.appRoxoTab) // Corrigido para as cores do seu DesignSystem
                    .cornerRadius(100)
                    .opacity(0.8)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        // ✅ ADICIONE ISSO AQUI: Esconde a barra de abas quando esta tela aparecer
        .toolbar(.hidden, for: .tabBar)
    }
}
#Preview {
    BiblioAgeView()
}
