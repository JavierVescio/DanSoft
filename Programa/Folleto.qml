import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import com.mednet.WrapperClassManagement 1.0
import com.mednet.CMAlumno 1.0

Rectangle {
    anchors.fill: parent
    property string strSource : "qrc:/media/Media/FolletoPuertoArgentino.png"
    property string strSource2 : "qrc:/media/Media/FolletoPuertoArgentino2.png"
    property string strSource3 : "qrc:/media/Media/FolletoPraderaDelGanso1.png"
    property string strSource4 : "qrc:/media/Media/FolletoPraderaDelGanso2.png"
    property string strSource5 : "qrc:/media/Media/FolletoPraderaDelGanso3.png"

    property string strTipo421 : "TIPO 42 O CLASE SHEFFIELD:\n\nClase de destructor inglés, equipado con potentes armas antiaéreas, empleado en la guerra de Malvinas. Este navío operó únicamente en la Royal Navy y en la Armada Argentina.
    Más aun, fue el primer conflicto desde la Segunda Guerra Mundial, en donde barcos de guerra del mismo diseño combatieron en lados opuestos (8u. Royal Navy, 2u. ARA).
    Debido a su poderío dentro de la flota, fue blanco preferencial para el ataque por parte de los pilotos argentinos. En muchas oportunidades, usando diversas y ya conocidas tácticas de vuelo, la Fuerza Aérea y la aviación naval, lograban sortear las defensas de la embarcación y atacarla de todas formas."

    property string strTipo422 : "HMS SHEFFIELD (D80):\n\nEl HMS Sheffield fue el primer navío Tipo 42 en ser entregado a la Royal Navy en 1975, participando años más tarde en la guerra de Malvinas. El 4 de mayo de 1982, a dos días del hundimiento del Crucero ARA General Belgrano por parte del submarino británico Conqueror, el HMS Sheffield fue hundido por la aviación naval de la Armada Argentina, convirtiéndose así en el primer barco de guerra enemigo hundido por las fuerzas argentinas.
\nEn primera instancia, la Task Force pensaba que el ataque había provenido de un submarino argentino, por lo que se dispuso la búsqueda inmediata de dicha supuesta unidad. Sin embargo, la acción fue suspendida al corroborarse que el daño en el Tipo 42 había sido por encima de su línea de flotación.
\nPor la magnitud y el estudio de los daños, todo apuntaba a que de alguna manera, la Argentina habría logrado descifrar la activación del misil AM39 Exocet por si misma (recientemente por aquel entonces comprados a Francia), pese a no haber recibido instrucciones de los franceses sobre su uso (por presiones de Inglaterra), y que habría empleado uno de sus cinco misiles para atacar al HMS Sheffield.
\nLa versión argentina cuenta que el ataque fue llevado a cabo por dos aviones Super Étendard de la Armada. Sin entrar en el radio de acción del enemigo (algo que los ingleses esperaban que sucediera), ambos 'engancharon' los blancos y cada uno disparó su Exocet. Inmediatamente después, los pilotos pusieron rumbo a casa. Los misiles continuaron el camino (algo más de 30km) a ras del agua hasta el blanco, impactando solo uno de ellos en él.
\nA bordo del barco fue todo sorpresa. Tan solo cinco segundos antes del impacto, el radar del Sheffield detectó la amenaza. No hubo nada que hacer. "

    property string strTipo423 : "HMS COVENTRY (D118):\n\nEl HMS Coventry fue el cuarto destructor Clase Tipo 42 entregado a la Royal Navy en 1978, siendo atacado el 25 de mayo de 1982 por aviones A-4B Skyhawk de la FAA y provocándole su hundimiento en tan solo 20 minutos en las aguas del Atlántico Sur.
Estando el Coventry en una misión de engaño junto a la fragata Tipo 22 HMS Broadsword, ambos logran derribar tres aviones argentinos, sin que ninguno de estos se dieran cuenta de la presencia de los navíos. Finalmente la FAA detecta la trampa y ordena atacar ambas embarcaciones.\nDurante un tiempo, el HMS Coventry ilumina en su radar a cuatro aviones distantes volando en formación pero luego desaparecen. Se sabía en el barco que el ataque llegaría en menos de una hora, por lo que la tripulación seguía intentando localizar a los aviones.
Finalmente algo aparece en el radar. Cuando el Coventry detecta a la primera oleada de Skyhawks aproximándose (compuesta por dos unidades), se encuentra con un problema. Los cazabombarderos argentinos venían volando tan bajo y juntos, que la computadora de disparo del Coventry fallaba al intentar enganchar los blancos, ya que no podía distinguir entre ellos y la superficie. Incluso por volar tan 'pegados', lo que la computadora entendía como dos blancos, luego se transformaban en solamente uno, causando inevitablemente la falla en el sistema de tiro.\n
La seguridad del Coventry en esta primera oleada ahora dependía de sus cañones de menor tecnología, pero principalmente de su compañera Tipo 22 HMS Broadsword, que estaba equipada con misiles Sea Wolf para su uso a corta distancia. Sin embargo, el sistema de rastreo de la fragata se cae a último momento, obligando a los operarios a reiniciar el sistema, aun ya a sabiendas de que no habría más tiempo. Los A-4 sobrepasan al Coventry y sueltan sus bombas en el Broadsword, aunque solo una de ellas impacta (sin explotar) en la cubierta de vuelo, destrozando el helicóptero Westland Lynx que había allí.\n
Poco más de un minuto después se aproxima la segunda oleada de Skyhawks, compuesta por las otras dos unidades, esta vez con el objetivo de 'golpear' al Coventry. El Coventry logra enganchar un blanco pero instante antes de que el operario accionara el botón de disparo, la computadora lo pierde, por lo que el misil Sea Dart salió disparado al aire como un cohete sin dirección alguna. No hay tiempo para un segundo intento de disparo por parte del Coventry (simplemente este atina a hacer un viraje defensivo) y nuevamente toda la responsabilidad recae en el HMS Broadsword. Esta vez, la fragata Tipo 22 ha logrado reiniciar su sistema de tiro del misil Sea Wolf y está preparada para atacar y salvar a su compañero. Pero increíblemente, el último viraje del Coventry, se interpone en la línea de fuego del Broadsword. Solo faltan segundos para el ataque argentino al Tipo 42 y desde la otra embarcación miran con impotencia, ya no pudiendo hacer nada para defenderle.\n\nLos aviones lanzan sus bombas, dos de ellas explotan en el destructor, y le producen graves daños, además de un incendio incontrolable. El Coventry se hunde en cuestión de minutos. Es destacable el éxito de la misión argentina, sumado a que no se produjeron bajas y más aun, durante una fecha patria."

    property string strTipo424 : "ARA SANTÍSIMA TRINIDAD (D-2) y ARA HÉRCULES (D-28):\n\nLos entonces modernos destructores ARA Santísima Trinidad (D-2) y ARA Hércules (D-28) fueron los únicos navíos Clase Tipo 42 que disponía la Armada Argentina al momento de entrar en el conflicto armado con Inglaterra. Curiosamente, cinco meses antes del conflicto, el Santísima Trinidad se encontraba en Inglaterra haciendo pruebas de sus sistemas de tiro. Ambos destructores fueron adquiridos para dar cobertura antiaérea al portaaviones ARA 25 de Mayo.
Durante el conflicto y a sabiendas de que Inglaterra también usaría sus destructores Tipo 42, Argentina comenzó a estudiar sus propias embarcaciones de la misma clase a fin de detectar sus puntos débiles. Se concluyó que, si los aviones volaban muy bajo, serían indetectables ante los radares del navío, quedando los aviones fuera de la zona de peligro de los misiles antiaéreos. De allí que los pilotos argentinos siempre volaran en rasante.
Finalizada la guerra, Inglaterra estableció embargos a la Argentina y a consecuencia de ello, resultaba prácticamente imposible conseguir repuestos para una clase de embarcación que había sido desarrollada para la Marina Real Británica. Se decidió entonces dejar fuera de servicio al ARA Santísima Trinidad para que esta sirviera de repuestos al destructor ARA Hércules, aun en servicio para la Armada Argentina, siendo hoy en día el único destructor Tipo 42 activo en el mundo."

    property string strPeru1: "REPÚBLICA DEL PERÚ:\n\nPerú es el tercer país más grande de Sudamérica, con alrededor de 30 millones de habitantes.
El área que ahora es Perú estaba habitada por muchos grupos indígenas, y con el tiempo muchos fueron conquistados por los incas. Los incas, a su vez, fueron conquistados por los españoles.
En el siglo XIX surgió la Expedición Libertadora del Perú encabezada por el general argentino José de San Martín con la misión de independizar al Perú.
La proclamación de la independencia fue llevada a cabo el 28 de julio de 1821, cuando el general San Martín, instauró un nuevo Estado: la República del Perú.

“Perú” proviene del vocablo quechua que significa “abundancia”en referencia al bienestar y opulencia del imperio incaico.
Dos tercios del territorio están cubiertos de selva amazónica. La Universidad Nacional de San Marcos, ubicada en Lima, es la más antigua de las Américas, siendo fundada en 1551.

"

    property string strPeru2: "CUZCO Y MACHU PICCHU:\n\nSabías que... El centro desde el que se irradió la cultura incaica fue el valle del Cuzco.
Cuzco fue la antigua capital incaica. Tiene hoy gran valor histórico y arqueológico, y se encuentran allí las manifestaciones de la arquitectura colonial.
Cuzco fue declarado Patrimonio Histórico de la Humanidad en 1983.
Las ruinas de Machu Picchu, la ciudadela de los Incas, situada a 2700 metros entre los desfiladeros de Urubamba, fueron descubiertas en 1911, por el arqueólogo e historiador norteamericano Hiram Bingham. Muchos investigadores habían pasado por sus cercanías anteriormente, sin descubrirla.
"

    property string strPeru3: "LÍNEAS DE NAZCA:\n\nSabías que... Las líneas de Nazca fueron descubiertas en 1930, por unos aviadores que observaron que las líneas formaban dibujos de animales y figuras geométricas.. Se observan desde alturas, y ocupan unos 1.500 metros de largo.
Las líneas de Nazca son de una técnica impecable. Las rectas presentan una linealidad perfecta, con insignificantes desviaciones a lo largo de kilómetros. Las curvas y volutas parecen trazadas con  útiles geométricos."

    property string strPeru4: "AYUDA MILITAR DEL PERÚ A LA ARGENTINA EN LA GUERRA DE MALVINAS:\n\nSabías que... En una operación militar secreta, Perú envió 10 aviones Mirage a la Argentina. Los mismos volaron con las insignias de la Argentina en lugar de las peruanas. Evitaron ser detectados por radares chilenos (ya que se sabía que Chile estaba alineado con los ingleses), porque era importante que no se supiera del apoyo militar peruano. En reiteradas oportunidades, armamento que compraba Perú para sus Fuerzas Armadas, en realidad iban a parar después a la Argentina, quien tenía dificultades para conseguirlos por embargos impuestos por UK.

Junio de 1982, a pocos días de la caída de Puerto Argentino
Tras la llegada de los aviones de guerra Mirage M5-P de Perú a nuestro país, los pocos pilotos argentinos de Dagger que se hallaban en la base aérea (los otros estaban combatiendo) se estrecharon en sincero abrazo con sus colegas peruanos. 'Algunos estuvieron al borde de las lágrimas. Imagínese que a usted le llevan ayuda militar cuando más la necesita y en momentos cruciales. No era para menos', recordó el General de la Fuerza Aérea del Perú, Aurelio Crovetto Yáñez, quien más tarde se encargaría de dar instrucción a sus colegas argentinos."

    property string strPeru5: "AYUDA MILITAR DEL PERÚ A LA ARGENTINA EN LA GUERRA DE MALVINAS:\n\nSabías que... Las Fuerzas Armadas del Perú sirvieron de freno a las chilenas para evitarle a la Argentina pelear en dos frentes. Para este objetivo, Perú movilizó gran parte de su flota a los puertos del sur del Perú y se incrementaron los ejercicios de blindados sobre la zona de frontera con Chile. La señal era clara y fue captada por los chilenos. Si Chile atacaba Argentina mientras ésta estaba ocupada peleando contra los ingleses, Perú invadiría el territorio chileno.
"

    opacity: 0
    enabled: false
    property variant p_objPestania

    Behavior on opacity {PropertyAnimation{}}

    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: combo.height + 10
        height: 400
        width: parent.width
        z: 1
        clip: true
        contentHeight: lblTexto.height

        enabled: lblTexto.text !== ""

        Text {
            id: lblTexto
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.family: "verdana"
            font.pixelSize: 14
            color: "black"
            antialiasing: true
        }
    }

    ComboBox {
        id: combo
        z: 50
        anchors.left: parent.left
        anchors.top: parent.top
        width: 250
        model: [
            "v1.0 Puerto Argentino - Historia 1 - DESEMBARCO",
            "v1.0 Puerto Argentino - Historia 2 - DESINTERÉS POR MALVINAS",
            "v1.1 Pradera del Ganso - Historia 1 - TENIENTE ESTÉVEZ",
            "v1.1 Pradera del Ganso - Historia 2 - FMA IA-58 PUCARÁ",
            "v1.1 Pradera del Ganso - Historia 3 - MAYOR CHRIS KEEBLE",
            "v1.2 Tipo 42 - Historia 1 - TIPO 42 O CLASE SHEFFIELD",
            "v1.2 Tipo 42 - Historia 2 - HMS SHEFFIELD (D80)",
            "v1.2 Tipo 42 - Historia 3 - HMS COVENTRY (D118)",
            "v1.2 Tipo 42 - Historia 4 - ARA SANTÍSIMA TRINIDAD (D-2) Y ARA HÉRCULES (D-28)",
            "v2.0 República del Perú - Historia 1 - PERÚ",
            "v2.0 República del Perú - Historia 2 - CUZCO Y MACHU PICCHU",
            "v2.0 República del Perú - Historia 3 - LÍNEAS DE NAZCA",
            "v2.0 República del Perú - Historia 4 - AYUDA MILITAR",
            "v2.0 República del Perú - Historia 5 - AYUDA MILITAR"
        ]

        onCurrentIndexChanged: {
            elegirFolleto(currentIndex)
        }
    }

    function elegirFolleto(aleatorio) {
        if (aleatorio > 4) {
            imgFolleto.source = "qrc:/media/Media/islas.PNG"
            imgFolleto.opacity = 0.2
        }
        else {
            imgFolleto.opacity = 1
            lblTexto.text = ""
        }

        switch (aleatorio) {
        case 0 :
            imgFolleto.source = strSource
            break;
        case 1 :
            imgFolleto.source = strSource2
            break;
        case 2 :
            imgFolleto.source = strSource3
            break;
        case 3 :
            imgFolleto.source = strSource4
            break;
        case 4 :
            imgFolleto.source = strSource5
            break;
        case 5 :
            lblTexto.text = strTipo421
            break;
        case 6 :
            lblTexto.text = strTipo422
            break;
        case 7 :
            lblTexto.text = strTipo423
            break;
        case 8 :
            lblTexto.text = strTipo424
            break;
        case 9 :
            lblTexto.text = strPeru1
            break;
        case 10 :
            lblTexto.text = strPeru2
            break;
        case 11 :
            lblTexto.text = strPeru3
            break;
        case 12 :
            lblTexto.text = strPeru4
            break;
        case 13 :
            lblTexto.text = strPeru5
            break;
        }
    }

    Component.onCompleted: {
        elegirFolleto(0)
    }


    Flickable {
        anchors.fill: parent
        contentHeight: imgFolleto.height
        contentWidth: imgFolleto.width

        Image {
            id: imgFolleto
            source: ""
        }
    }
}

