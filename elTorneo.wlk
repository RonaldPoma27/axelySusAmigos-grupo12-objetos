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


/*
Finalmente se descubre que el problema es que un traje entero podía llegar a ser 
muy caro, por lo que se decide introducir un nuevo tipo de trajes:

Modularizados: estos trajes están conformados por un conjunto de piezas. Cada 
pieza tiene un porcentaje de resistencia y un valor de desgaste, y se la considera 
"gastada" cuando tiene un desgaste igual o mayor a 20 unidades. 

Al recibir un ataque, el daño disminuye en una cantidad de unidades igual a la 
sumatoria de las resistencias de cada pieza que no esté gastada. Un traje 
Modularizado está gastado si todas sus piezas están gastadas. 
Los trajes modularizados aumentan la experiencia en base al porcentaje de piezas 
que tenga que no estén gastadas, ejemplos:
Tengo 10 piezas, y tengo 0 gastadas, entonces la experiencia es aumentada al 100% 
[1 punto aumenta].
Tengo 10 piezas, y tengo 5 gastadas, entonces la experiencia es aumentada en un 
50% [0.5 punto aumenta].
Tengo 10 piezas, y tengo 2 gastadas, entonces la experiencia es aumentada en un 
80% [0.8 punto aumenta].


*/
