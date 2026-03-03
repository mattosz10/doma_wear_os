# ⌚ DOMA Wear OS - Smart Fitness Timer

Este projeto foi desenvolvido como parte da disciplina de Desenvolvimento Mobile/Wearables. O objetivo é criar um cronômetro inteligente para Wear OS (Android) que demonstra integração profunda com o hardware nativo do dispositivo via MethodChannels.

🔗 **Link do Repositório:** [https://github.com/mattosz10/doma_wear_os](https://github.com/mattosz10/doma_wear_os)

## 🚀 Funcionalidades Principais

* **Cronômetro de Treino:** Interface otimizada para telas circulares (SingleChildScrollView) para evitar overflow.
* **Feedback Tátil (Haptic):** Vibração ao atingir 10 segundos para alerta de marcos de treino.
* **Gestão de Áudio Nativa (Kotlin):**
    * Identificação de alto-falantes e Bluetooth (`AudioDeviceInfo`).
    * Detecção dinâmica via `registerAudioDeviceCallback`.
    * Atalho direto para Configurações de Bluetooth via Intent Nativa.
* **Feedback Auditivo:** Alerta sonoro de sistema ao atingir tempos específicos (Item 6 do roteiro).

## 🛠️ Tecnologias Utilizadas

* **Flutter:** Interface e lógica de estado.
* **Kotlin (Android Nativo):** Acesso às APIs de hardware e sistema operacional.
* **Audioplayers:** Plugin para execução de áudio.

## ⚙️ Como Executar

1. Clone o repositório:
   ```bash
   git clone [https://github.com/mattosz10/doma_wear_os.git](https://github.com/mattosz10/doma_wear_os.git)
