import SwiftUI

struct BiblioAgeView: View {
    @Environment(\.dismiss) var dismiss
    
    let idades: [String] = ["4 - 5", "6 - 7", "8 - 10"]
    
    // Altere de @State para @Binding e remova a inicialização direta
    @Binding var idadeSelecionada: String
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 30) {
                    Text("Selecione uma classificação")
                        .font(FontesDoApp.xBold(tamanho: 25))
                        .foregroundColor(.roxoTab)
                    
                    Picker("Selecione sua idade", selection: $idadeSelecionada) {
                        ForEach(idades, id: \.self) { idade in
                            Text(idade).tag(idade)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 10) {
                        Text("Confirmar")
                            .font(FontesDoApp.x(tamanho: 16))
                    }
                    .foregroundColor(.white)
                    .frame(width: 320, height: 50)
                    .background(Color.roxoTab)
                    .cornerRadius(100)
                    .opacity(0.8)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// Atualize o Preview passando um valor constante simulado
#Preview {
    BiblioAgeView(idadeSelecionada: .constant("4 - 5"))
}
