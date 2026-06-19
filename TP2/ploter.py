import sounddevice as sd
import numpy as np
import matplotlib.pyplot as plt

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
        data, overflow = stream.read(CHUNK)
        data = data[:,0] 
        line_time.set_ydata(data) #Visualização da onda

        window = np.hanning(CHUNK)

        #Visualização em fft, 
        fft = np.abs(
            np.fft.rfft(data * window)
        )
        line_fft.set_ydata(fft)
        fig.canvas.draw()
        fig.canvas.flush_events()

except KeyboardInterrupt:
    print("\nPrograma Teste encerrado")

finally:
    stream.stop()
    stream.close()
    plt.close()
