class Guerrero {
  const property potencialOfensivo
  const property energiaOriginal
  var property energia
  var property experiencia = 0
  var property traje

  method atacar(otroGuerrero) {
    otroGuerrero.recibirAtaque(potencialOfensivo)
  }

  method recibirAtaque(potencialDelAtacante) {
    const danioBase = potencialDelAtacante * 0.1
    const danioFinal = traje.danioRecibido(danioBase)
    energia = (energia - danioFinal).max(0)
    experiencia += traje.experienciaPorAtaque()
  }

  method comerSemilla() {
    energia = energiaOriginal
  }
}