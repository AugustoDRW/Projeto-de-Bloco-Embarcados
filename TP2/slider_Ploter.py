import tkinter as tk
import sounddevice as sd
import numpy as np
import matplotlib.pyplot as plt

#Configurações da janela
slider = tk.Tk()
slider.title("My First Tkinter App")
slider.geometry("100x400")
label = tk.Label(slider, text="Visualização de som", font=("Arial", 14))
ganho_label = tk.Label(slider,text="Volume: 0",font=("Arial", 12))
ganho_label.pack()

#Slider e função de almentar volume
ganho = 0
def atualizar_volume(valor):
    global ganho
    ganho = float(valor)/127.5
    volume = int((ganho/2)* 100) 
    ganho_label.config(text=f"Volume: {volume}%")

volume_ch1 = tk.Scale(
    slider,
    from_=0,
    to=255,
    orient="vertical",
    length=300,
    width=20,
    sliderlength=30,
    command=atualizar_volume
)
volume_ch1.pack()

#Ploter =======================================================================================================
CHUNK = 1024
RATE = 44100

plt.ion()

fig, (ax1, ax2) = plt.subplots(2, 1)

# Forma de onda =============================================================
x_time = np.arange(CHUNK)
line_time, = ax1.plot(x_time, np.zeros(CHUNK))

ax1.set_title("Forma de Onda")
ax1.set_ylim(-0.25, 0.25) #Escala baixa para facilitar a visualização dos graficos
ax1.set_xlim(0, CHUNK)

# Forma de onda =============================================================
freqs = np.fft.rfftfreq(CHUNK, 1/RATE)

line_fft, = ax2.plot(freqs, np.zeros(len(freqs)))

ax2.set_title("Espectro")
ax2.set_xlim(0, RATE/2)
ax2.set_ylim(0, 50)

stream = sd.InputStream(
    channels=1,
    samplerate=RATE,
    blocksize=CHUNK,
    dtype='float32'
)

stream.start()

print("Gravando | Pressione Ctrl+C para parar.")

try:
    while True:
        slider.update()

        data, overflow = stream.read(CHUNK)
        data = data[:,0] * ganho
        line_time.set_ydata(data) #Visualização da onda
 
        window = np.hanning(CHUNK)
        
        #Visualização em fft, 
        fft = np.abs(
            np.fft.rfft(data * window)
        )
        line_fft.set_ydata(fft)
        fig.canvas.draw()
        fig.canvas.flush_events()

except tk.TclError:
    pass


except KeyboardInterrupt:
    print("\nPrograma Teste encerrado")

finally:
    stream.stop()
    stream.close()
    plt.close()



