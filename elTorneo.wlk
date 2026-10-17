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
    const danioFinal = traje.danioRecibido(danioBase,potencialDelAtacante)
    energia = (energia - danioFinal).max(0)
    experiencia += traje.experienciaPorAtaque()
  }

  method comerSemilla() {
    energia = energiaOriginal
  }

  // EJ. 5: cuantas piezas tiene el traje del guerrero (lo usa la modalidad funny).
  // El guerrero no sabe que traje tiene, se lo delega al traje (polimorfismo)
  method cantidadDePiezas() = traje.cantidadDePiezas()
}



class trajeComun {
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

  // EJ. 5: un traje enterizo cuenta como 1 pieza
  method cantidadDePiezas() = 1

}

class trajeDeEntrenamiento {
  var desgaste=0
  method danioRecibido(danioBase,potencialDelAtacante)= danioBase

  method experienciaPorAtaque() = 2

  method trajeGastado()=desgaste>=100

  method usar() {
    desgaste+=5
  }

  // EJ. 5: un traje enterizo cuenta como 1 pieza
  method cantidadDePiezas() = 1

}



// ============================================================
//  EJERCICIO 4: TRAJES MODULARIZADOS
// ============================================================

// Traje formado por un conjunto de piezas
class trajeModularizados {

  const property piezas = []

  // Las piezas que todavia sirven (no gastadas)
  method piezasSinGastar()= piezas.filter({pieza=>!pieza.gastada()})

  // Suma de las resistencias de las piezas no gastadas
  method resistenciaTotal() = self.piezasSinGastar().sum({pieza=>pieza.porcentaje()})

  // Esta gastado si TODAS sus piezas estan gastadas (no queda ninguna sana)
  method trajeGastado() = self.piezasSinGastar().isEmpty()

  // Experiencia proporcional a las piezas sanas
  // ej: 10 piezas con 2 gastadas -> 8/10 = 0.8
  method experienciaPorAtaque() = self.piezasSinGastar().size()/piezas.size()

  // El daño baja en la suma de resistencias (sin quedar negativo)
  method danioRecibido(danioBase,potencialDelAtacante) = (danioBase - self.resistenciaTotal()).max(0)

  // Al usar el traje se desgastan todas sus piezas
  method usar() {
    piezas.forEach({pieza => pieza.usar()})
  }

  // EJ. 5: un traje modularizado suma 1 por cada pieza
  method cantidadDePiezas() = piezas.size()

}

// Cada pieza tiene una resistencia y un desgaste propio
class Pieza {
  var porcentajeResistencia=0
  var property desgaste=0

  method porcentaje() = porcentajeResistencia

  // Una pieza esta gastada con 20 o mas de desgaste
  method gastada() = desgaste>=20

  method usar() {
    desgaste+=5
  }
}



// ============================================================
//  EJERCICIO 5: TORNEO
//  El torneo tiene una modalidad que decide como se eligen
//  los participantes. Cada modalidad es un objeto distinto que
//  entiende seleccionar(guerreros, cupo), asi se pueden
//  intercambiar sin cambiar el torneo (polimorfismo).
// ============================================================

class Torneo {
  var property modalidad   // powerIsBest, funny o surprise (se puede cambiar)
  const cupo = 16          // cantidad de peleadores que entran al torneo

  // Le pide a la modalidad que elija los participantes
  method seleccionar(guerreros) = modalidad.seleccionar(guerreros, cupo)
}

// PowerIsBest: los 16 con mas potencial ofensivo
object powerIsBest {
  method seleccionar(guerreros, cupo) =
    guerreros.sortedBy({a, b => a.potencialOfensivo() > b.potencialOfensivo()}).take(cupo)
}

// Funny: los 16 con mas piezas en el traje
object funny {
  method seleccionar(guerreros, cupo) =
    guerreros.sortedBy({a, b => a.cantidadDePiezas() > b.cantidadDePiezas()}).take(cupo)
}

// Surprise: 16 al azar, sin repetir
// (va sacando uno al azar de los disponibles hasta llenar el cupo)
object surprise {
  method seleccionar(guerreros, cupo) {
    const disponibles = guerreros.copy()
    const elegidos = []
    guerreros.size().min(cupo).times({ i =>
      const elegido = disponibles.anyOne()
      elegidos.add(elegido)
      disponibles.remove(elegido)
    })
    return elegidos
  }
}