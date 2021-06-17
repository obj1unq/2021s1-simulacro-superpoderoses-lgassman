/** Reemplazar por la solución del enunciado */
class Personaje {
	
	var property estrategia
	var property espiritualidad
	const poderes = #{}
	
	method capacidadDeBatalla() {
		return poderes.sum({poder => self.capacidadQueAporta(poder)})
	}
	
	method capacidadQueAporta(poder) {
		return poder.capacidadDeBatallaQueAporta(self)
	}
	
	method mejorPoder() {
		return poderes.max({poder => poder.capacidadDeBatallaQueAporta(self)}) 
	}
	
	method esInmuneARadiacion() {
		return poderes.any({poder => poder.daInmunidad()})
	}
	
	method validarEnfrentar(peligro) {
		if( not peligro.puedeSerEnfrentadoPor(self)) {
			self.error("no puede enfrentar a " + peligro)
		}
		
	}
	
	method enfrentar(peligro) {
		self.validarEnfrentar(peligro)
		self.efectoDeEnfrentar(peligro)
	}
	
	method efectoDeEnfrentar(peligro) {
		estrategia += peligro.complejidad()		
	}
	
}

class Metahumano inherits Personaje {
	override method capacidadDeBatalla() {
		return super() * 2
	}
	
	override method esInmuneARadiacion() {
		return true
	}
	
	override method efectoDeEnfrentar(peligro) {
		super(peligro)
		espiritualidad+=peligro.complejidad()
	}
	
}

class Mago inherits Metahumano {
	var property poderAcumulado
	
	override method capacidadDeBatalla() {
		return super() + poderAcumulado
	}
	
	override method efectoDeEnfrentar(peligro) {
		if(poderAcumulado > 10) {
			super(peligro)
		}
		poderAcumulado = (poderAcumulado - 5).max(0)
	}
	
}

class Poder {
	
	method capacidadDeBatallaQueAporta(personaje) {
		return (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje)
	}
	
	method agilidad(personaje)
	method fuerza(personaje)

	method habilidadEspecial(personaje) {
		return personaje.estrategia() + personaje.espiritualidad()
	}
	
	method daInmunidad()
}

class Velocidad inherits Poder {
	
	const rapidez
	
	override method agilidad(personaje) {
		return personaje.estrategia() * rapidez
	}

	override method fuerza(personaje) {
		return personaje.espiritualidad() * rapidez
	}
	
	override method daInmunidad() {
		return false
	}
	
}

class Vuelo inherits Poder {
	
	const alturaMaxima
	const energiaParaDespegue
	
	override method agilidad(personaje) {
		return personaje.estrategia() * alturaMaxima / energiaParaDespegue
	}

	override method fuerza(personaje) {
		return personaje.espiritualidad() + alturaMaxima - energiaParaDespegue
	}

	override method daInmunidad() {
		return alturaMaxima > 200
	}
	
}

class Amplificador inherits Poder {
	const poderBase
	const amplificador
	
	override method agilidad(personaje) {
		return poderBase.agilidad(personaje)
	}
	
	override method fuerza(personaje) {
		return poderBase.fuerza(personaje)
	}
	
	override method habilidadEspecial(personaje) {
		return poderBase.habilidadEspecial(personaje) * amplificador
	} 
	
	override method daInmunidad() {
		return true
	}
		
}

class Equipo {
	
	const property personajes = #{}
	
	method masVulnerable() {
		return personajes.min({personaje => personaje.capacidadDeBatalla()})
	}
	
	method calidad() {
		return self.sumatoriaCapacidades() / self.cantidadMiembros()
	}
	
	method sumatoriaCapacidades() {
		return personajes.sum({personaje => personaje.capacidadDeBatalla()})
	}
	
	method cantidadMiembros() {
	 	return personajes.size()
	}
	
	method mejoresPoderes() {
		return personajes.map({personaje => personaje.mejorPoder()}).asSet()
	}
	
	method esSensato(peligro) {
		return personajes.all({personaje => peligro.puedeSerEnfrentadoPor(personaje)})
	}
	
	
	
	method validarEnfrentar(peligro) {
		if(peligro.cantidadQueSeBanca() >= self.cantidadPersonajesQuePuedenEnfrentar(peligro)) {
			self.error("no se puede lanzar el error")
		}	
	}
	
	method cantidadPersonajesQuePuedenEnfrentar(peligro) {
		return personajes.count({personaje => peligro.puedeSerEnfrentadoPor(personaje)})
	}
	
	method enfrentar(peligro) {
		self.validarEnfrentar(peligro)
		self.personajesQuePuedenEnfrentar(peligro).forEach({personaje => personaje.enfrentar(peligro)})
	}
	
	method personajesQuePuedenEnfrentar(peligro) {
		return personajes.filter({personaje=>peligro.puedeSerEnfrentadoPor(personaje)})
	}
}

class Peligro {
	const capacidadDeBatalla
	const tieneDesechosRadiactivos
	const property complejidad
	const property cantidadQueSeBanca
	
	method puedeSerEnfrentadoPor(personaje) {
		return self.superaPoderBatalla(personaje) and
			self.manejaRadiactividad(personaje)
	}
	
	method superaPoderBatalla(personaje) {
		return personaje.capacidadDeBatalla() > capacidadDeBatalla
	}
	
	method manejaRadiactividad(personaje) {
		return not tieneDesechosRadiactivos or personaje.esInmuneARadiacion()
	}
	
	method esSensato(equipo) {
		return equipo.esSensato(self)
	}
	
	
}


