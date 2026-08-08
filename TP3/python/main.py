import tkinter as tk
import spidev

SPI_BUS = 0
SPI_DEVICE = 0
SPI_SPEED = 100_000

spi = spidev.SpiDev()
spi.open(SPI_BUS, SPI_DEVICE)
spi.mode = 0
spi.max_speed_hz = SPI_SPEED
spi.bits_per_word = 8


def enviar_volumes(_valor=None):
    volume_1 = int(slider_1.get())
    volume_2 = int(slider_2.get())

    spi.xfer2([volume_1, volume_2])

    label_1.config(text=f"Canal 1: {volume_1}")
    label_2.config(text=f"Canal 2: {volume_2}")


def fechar():
    spi.close()
    janela.destroy()


janela = tk.Tk()
janela.title("Mesa de Som 2 canais")
janela.geometry("500x430")

frame = tk.Frame(janela)
frame.pack(pady=10)

label_1 = tk.Label(frame, text="Canal 1: 128", font=("Arial", 14))
label_1.grid(row=0, column=0, padx=40)

label_2 = tk.Label(frame, text="Canal 2: 128", font=("Arial", 14))
label_2.grid(row=0, column=1, padx=40)

slider_1 = tk.Scale(
    frame,
    from_=255,
    to=0,
    orient=tk.VERTICAL,
      length=300,
    width=25,
    command=enviar_volumes
)

slider_1.grid(row=1, column=0)

slider_2 = tk.Scale(
    frame,
    from_=255,
    to=0,
    orient=tk.VERTICAL,
    length=300,
    width=25,
    command=enviar_volumes
)

slider_2.grid(row=1, column=1)

slider_1.set(128)
slider_2.set(128)

janela.protocol("WM_DELETE_WINDOW", fechar)
janela.mainloop()
