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


