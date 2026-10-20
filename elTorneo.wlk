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
    traje.usar()
    const danioBase = potencialDelAtacante * 0.1
    const danioFinal = traje.danioRecibido(danioBase,potencialDelAtacante)
    energia = (energia - danioFinal).max(0)
    experiencia += traje.experienciaPorAtaque()
  }

  method comerSemilla() {
    energia = energiaOriginal
  }

  //ej5
  method cantidadDePiezas() = traje.cantidadDePiezas()
}



class TrajeComun {
  var porcentajeDeDanio=0
  var experiencia = 1
  var desgaste = 0
  method danioRecibido(danioBase, potencialDelAtacante){

    if(self.trajeGastado()){
      return danioBase
    }
    else{
      return danioBase-(potencialDelAtacante*porcentajeDeDanio)
    }

  }

  method experienciaPorAtaque() = experiencia

  method trajeGastado()= desgaste>=100

  method usar() {
    desgaste+=5
  }

  //ej5
  method cantidadDePiezas() = 1
  


}

class TrajeDeEntrenamiento {
  var desgaste=0
  method danioRecibido(danioBase,potencialDelAtacante)= danioBase

  method experienciaPorAtaque() = 2

  method trajeGastado()=desgaste>=100

  method usar() {
    desgaste+=5
  }

  //ej5
  method cantidadDePiezas() = 1

}

object creadorDeTrajes {
  method crearTraje(piezas) {
    if (piezas.isEmpty()) {
      throw new Exception(message = "El traje debe tener al menos una pieza")
    }
    return new TrajeModularizados(piezas = piezas)
  }
}

class TrajeModularizados {

  const property piezas = []

  method piezasSinGastar()= piezas.filter({pieza=>!pieza.gastada()})

  method resistenciaTotal() = self.piezasSinGastar().sum({pieza=>pieza.porcentaje()})

  method trajeGastado() = self.piezasSinGastar().isEmpty()

  method experienciaPorAtaque() = self.piezasSinGastar().size() / self.cantidadDePiezas()
  
  method danioRecibido(danioBase,potencialDelAtacante) = (danioBase - self.resistenciaTotal()).max(0)
  
  method usar() = piezas.forEach({pieza => pieza.usar()})

  //ej5
  method cantidadDePiezas() = piezas.size()

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


class Torneo {
  var property modalidad   
  const cupo = 16          
  method seleccionar(guerreros) = modalidad.seleccionar(guerreros, cupo)
}



object powerIsBest {
  method seleccionar(guerreros, cupo) = guerreros.sortedBy({guerrero1, guerrero2 => guerrero1.potencialOfensivo() > guerrero2.potencialOfensivo()}).take(cupo)
}


object funny {
  method seleccionar(guerreros, cupo) = guerreros.sortedBy({guerrero1, guerrero2 => guerrero1.cantidadDePiezas() > guerrero2.cantidadDePiezas()}).take(cupo)
}

object surprise {
  method seleccionar(guerreros, cupo) = guerreros.randomized().take(cupo)
}
// object surprise {
//   method seleccionar(guerreros, cupo) {
//     const disponibles = guerreros.copy()
//     const elegidos = []
//     guerreros.size().min(cupo).times({ i =>
//       const elegido = disponibles.anyOne()
//       elegidos.add(elegido)
//       disponibles.remove(elegido)
//     })
//     return elegidos
//   }
// }