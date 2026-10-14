class Guerrero {
  const property potencialOfensivo=0
  const property energiaOriginal=0
  var property energia = 0
  var property experiencia = 0
  var property traje

  method atacar(otroGuerrero) {
    otroGuerrero.recibirAtaque(potencialOfensivo)
  }

  method recibirAtaque(potencialDelAtacante) {
    traje.usar()
    const danioBase = potencialDelAtacante * 0.1
    const danioFinal = traje.danioRecibido(danioBase)
    energia = (energia - danioFinal).max(0)
    experiencia += traje.experienciaPorAtaque()
  }

  method comerSemilla() {
    energia = energiaOriginal
  }
}



class trajeComun {
  var porcentajeDeDanio=0
  var experiencia = 1
  var desgaste = 0
  method danioRecibido(danioBase){

    if(self.trajeGastado()){
      return danioBase
    }
    else{
      return danioBase-(danioBase*porcentajeDeDanio)
    }

  }

  method experienciaPorAtaque() = experiencia

  method trajeGastado()= desgaste>=100

  method usar() {
    desgaste+=5
  }

}

class trajeDeEntrenamiento {
  var desgaste=0
  method danioRecibido(danioBase)= danioBase

  method experienciaPorAtaque() = 2

  method trajeGastado()=desgaste>=100

  method usar() {
    desgaste+=5
  }

}

class trajeModularizados {

  const piezas = []

  method piezasSinGastar()= piezas.filter({pieza=>!pieza.gastada()})


  method resistenciaTotal() = self.piezasSinGastar().sum({pieza=>pieza.porcentaje()})

  method trajeGastado() = self.piezasSinGastar().isEmpty()

  method experienciaPorAtaque() = self.piezasSinGastar().size()/piezas.size()
  
  method danioRecibido(danioBase) = (danioBase - self.resistenciaTotal()).max(0)
  
  method usar() = piezas.forEach({pieza => pieza.usar()})

}

class Pieza {
  var porcentajeResistencia=0
  var desgaste=0

  method porcentaje() = porcentajeResistencia
  method gastada() = desgaste>=20

  method usar() {
    desgaste+=5
  }
}

