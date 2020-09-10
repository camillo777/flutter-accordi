class DataMusicTheory {

  static List<Map> get getAllScaleTypes => _scaleTypesAll;
  static List<Map> get getAllChordTypes => _chordTypesAll;
  static List<Map> get getAllIntervalTypes => _intervalTypesAll;

  // Successione intervallare scale
  // static Map<String, List<int>> _scaleTypesRaw = {
  //   "Diatonica Maggiore": [2, 2, 1, 2, 2, 2, 1],
  //   "Pentatonica maggiore": [2, 2, 3, 2, 3],
  //   "Minore naturale": [2, 1, 2, 2, 1, 2, 2],
  //   "Minore melodica": [2, 1, 2, 2, 2, 2, 1],
  //   "Minore armonica": [2, 1, 2, 2, 1, 3, 1],
  //   "Maggiore armonica": [2, 2, 1, 2, 1, 3, 1],
  //   "Orientale": [1, 3, 1, 1, 3, 1, 2],
  //   "Ungherese maggiore": [3, 1, 2, 1, 2, 1, 2],
  //   "Enigmatica": [1, 3, 2, 2, 2, 1, 1],
  //   "Napoletana": [1, 2, 2, 2, 2, 2, 1],
  //   "Napoletana minore": [1, 2, 2, 2, 1, 3, 1],
  //   "Ionica": [2, 2, 1, 2, 2, 2, 1],
  //   "Dorica": [2, 1, 2, 2, 2, 1, 2],
  //   "Frigia": [1, 2, 2, 2, 1, 2, 2],
  //   "Lidia": [2, 2, 2, 1, 2, 2, 1],
  //   "Misolidia": [2, 2, 1, 2, 2, 1, 2],
  //   "Eolia": [2, 1, 2, 2, 1, 2, 2],
  //   "Locria": [1, 2, 2, 1, 2, 2, 2]
  // };
  //static Map<String,List<int>> get getAllScaleTypes => _scaleTypes;

// Gradi costitutivi (gc.) scale
  // static Map<String, List<String>> _scaleTypesGCRaw = {
  //   "Diatonica maggiore": ["1", "2", "3", "4", "5", "6", "7"], // modo 1 ionico
  //   "Pentatonica maggiore": ["1", "2", "3", "5", "6"],
  //   "Minore naturale": ["1", "2", "3b", "4", "5", "6b", "7b"], // eolio
  //   "Minore melodica": ["1", "2", "3b", "4", "5", "6", "7"],
  //   "Minore armonica": ["1", "2", "3b", "4", "5", "6b", "7"],
  //   "Maggiore armonica": ["1", "2", "3", "4", "5", "6b", "7"],
  //   "Orientale": ["1", "2b", "3", "4", "5b", "6", "7b"],
  //   "Ungherese maggiore": ["1", "2#", "3", "4#", "5", "6", "7b"],
  //   "Enigmatica": ["1", "2b", "3", "4#", "5#", "6#", "7"],
  //   "Napoletana": ["1", "2b", "3b", "4", "5", "6b", "7"],
  //   "Napoletana minore": ["1", "2b", "3b", "4", "5", "6b", "7"],

  //   "Ionica": ["1", "2", "3", "4", "5", "6", "7"],
  //   "Dorica": ["1", "2", "3b", "4", "5", "6", "7b"],
  //   "Frigia": ["1", "2b", "3", "4", "5", "6b", "7b"],
  //   "Lidia": ["1", "2", "3", "4#", "5", "6", "7"],
  //   "Misolidia": ["1", "2", "3", "4", "5", "6", "7b"],
  //   "Eolia": ["1", "2", "3b", "4", "5", "6b", "7b"],
  //   "Locria": ["1", "2b", "3b", "4", "5b", "6b", "7b"]
  // };

  //static List<Map> get getAllScaleTypes => _scaleTypesAll;
  static List<Map> _scaleTypesAll = [
    {
      "name": "Diatonica Maggiore",
      "intervalli": [2, 2, 1, 2, 2, 2, 1],
      "gradi": ["1", "2", "3", "4", "5", "6", "7"]
    },
    {
      "name": "Pentatonica maggiore",
      "intervalli": [2, 2, 3, 2, 3],
      "gradi": ["1", "2", "3", "5", "6"]
    },
    {
      "name": "Minore naturale",
      "intervalli": [2, 1, 2, 2, 1, 2, 2],
      "gradi": ["1", "2", "3b", "4", "5", "6b", "7b"]
    },
    {
      "name": "Minore melodica",
      "intervalli": [2, 1, 2, 2, 2, 2, 1],
      "gradi": ["1", "2", "3b", "4", "5", "6", "7"]
    },
    {
      "name": "Minore armonica",
      "intervalli": [2, 1, 2, 2, 1, 3, 1],
      "gradi": ["1", "2", "3b", "4", "5", "6", "7"]
    },
    {
      "name": "Maggiore armonica",
      "intervalli": [2, 2, 1, 2, 1, 3, 1],
      "gradi": ["1", "2", "3", "4", "5", "6b", "7"]
    },
    {
      "name": "Orientale",
      "intervalli": [1, 3, 1, 1, 3, 1, 2],
      "gradi": ["1", "2b", "3", "4", "5b", "6", "7b"]
    },
    {
      "name": "Ungherese maggiore",
      "intervalli": [3, 1, 2, 1, 2, 1, 2],
      "gradi": ["1", "2#", "3", "4#", "5", "6", "7b"]
    },
    {
      "name": "Enigmatica",
      "intervalli": [1, 3, 2, 2, 2, 1, 1],
      "gradi": ["1", "2b", "3", "4#", "5#", "6#", "7"]
    },
    {
      "name": "Napoletana",
      "intervalli": [1, 2, 2, 2, 2, 2, 1],
      "gradi": ["1", "2b", "3b", "4", "5", "6b", "7"]
    },
    {
      "name": "Napoletana minore",
      "intervalli": [1, 2, 2, 2, 1, 3, 1],
      "gradi": ["1", "2b", "3b", "4", "5", "6b", "7"]
    },
    {
      "name": "Ionica",
      "intervalli": [2, 2, 1, 2, 2, 2, 1],
      "gradi": ["1", "2", "3", "4", "5", "6", "7"]
    },
    {
      "name": "Dorica",
      "intervalli": [2, 1, 2, 2, 2, 1, 2],
      "gradi": ["1", "2", "3b", "4", "5", "6", "7b"]
    },
    {
      "name": "Frigia",
      "intervalli": [1, 2, 2, 2, 1, 2, 2],
      "gradi": ["1", "2b", "3", "4", "5", "6b", "7b"]
    },
    {
      "name": "Lidia",
      "intervalli": [2, 2, 2, 1, 2, 2, 1],
      "gradi": ["1", "2", "3", "4#", "5", "6", "7"]
    },
    {
      "name": "Misolidia",
      "intervalli": [2, 2, 1, 2, 2, 1, 2],
      "gradi": ["1", "2", "3", "4", "5", "6", "7b"]
    },
    {
      "name": "Eolia",
      "intervalli": [2, 1, 2, 2, 1, 2, 2],
      "gradi": ["1", "2", "3b", "4", "5", "6b", "7b"]
    },
    {
      "name": "Locria",
      "intervalli": [1, 2, 2, 1, 2, 2, 2],
      "gradi": ["1", "2b", "3b", "4", "5b", "6b", "7b"]
    },
  ];

  // semitoni, nome intervallo
  static List<Map> _intervalTypesAll = [
    {
      "semitoni": 0,
      "intervallo": "1",
      "nome": "Unisono"
    },
    {
      "semitoni": 1,
      "intervallo": "2b",
      "nome": "Seconda minore"
    },
    {
      "semitoni": 2,
      "intervallo": "2",
      "nome": "Seconda maggiore"
    },
    {
      "semitoni": 3,
      "intervallo": "3b",
      "nome": "Terza minore"
    },
    {
      "semitoni": 4,
      "intervallo": "3",
      "nome": "Terza maggiore"
    },
    {
      "semitoni": 5,
      "intervallo": "4",
      "nome": "Quarta giusta"
    },
    {
      "semitoni": 6,
      "intervallo": "5b",
      "nome": "Quarta diminuita"
    },
    {
      "semitoni": 6,
      "intervallo": "4#",
      "nome": "Quarta aumentata"
    },
    {
      "semitoni": 7,
      "intervallo": "5",
      "nome": "Quinta giusta"
    },
    {
      "semitoni": 8,
      "intervallo": "6b",
      "nome": "Sesta minore"
    },
    {
      "semitoni": 8,
      "intervallo": "5#",
      "nome": "Quinta aumentata"
    },
    {
      "semitoni": 9,
      "intervallo": "6",
      "nome": "Sesta maggiore/Tredicesima maggiore"
    },
    {
      "semitoni": 9,
      "intervallo": "7bb",
      "nome": "Settima diminuita/Tredicesima maggiore"
    },
    {
      "semitoni": 10,
      "intervallo": "7b",
      "nome": "Settima minore"
    },
    {
      "semitoni": 11,
      "intervallo": "7",
      "nome": "Settima maggiore"
    },
    {
      "semitoni": 12,
      "intervallo": "8",
      "nome": "Ottava giusta"
    },
    {
      "semitoni": 13,
      "intervallo": "9b",
      "nome": "Nona minore"
    },
    {
      "semitoni": 14,
      "intervallo": "9",
      "nome": "Nona maggiore"
    },
    {
      "semitoni": 15,
      "intervallo": "9#",
      "nome": "Nona aumentata"
    },
    {
      "semitoni": 16,
      "intervallo": "",
      "nome": ""
    },
    {
      "semitoni": 17,
      "intervallo": "11",
      "nome": "Undicesima giusta"
    },
    {
      "semitoni": 18,
      "intervallo": "11#",
      "nome": "Undicesima aumentata"
    },
    {
      "semitoni": 19,
      "intervallo": "",
      "nome": ""
    },
    {
      "semitoni": 20,
      "intervallo": "13b",
      "nome": "Tredicesima minore"
    },
    {
      "semitoni": 21,
      "intervallo": "13",
      "nome": "Tredicesima maggiore"
    },
  ];

  static List<Map> _chordTypesAll = [
    {
      "gruppo": "Maggiori",
      "sigla": "M",
      "nome": "Maggiore",
      "gradi": ["1", "3", "5"],
      //I, IV, V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "maj7",
      "nome": "Settima maggiore",
      "gradi": ["1", "3", "5", "7"],
//I, IV
    },
    {
      "gruppo": "Maggiori",
      "sigla": "7",
      "nome": "Settima",
      "gradi": ["1", "3", "5", "7b"],
//V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "9add",
      "nome": "Nona aggiunta",
      "gradi": ["1", "3", "5", "9"],
// I, IV, V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "maj9",
      "nome": "Maggiore nona",
      "gradi": ["1", "3", "5", "7", "9"],
// I, IV
    },
    {
      "gruppo": "Maggiori",
      "sigla": "9",
      "nome": "Nona",
      "gradi": ["1", "3", "5", "7b", "9"],
// V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "7+9",
      "nome": "Nona aumentata",
      "gradi": ["1", "3", "5", "7b", "9#"],
//
    },
    {
      "gruppo": "Maggiori",
      "sigla": "7-9",
      "nome": "Nona minore",
      "gradi": ["1", "3", "5", "7b", "9b"],
//
    },
    {
      "gruppo": "Maggiori",
      "sigla": "11",
      "nome": "Undicesima",
      "gradi": ["1", "3", "5", "7b", "9", "11"],
// V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "+11",
      "nome": "Undicesima aumentata",
      "gradi": ["1", "3", "5", "7b", "9", "11#"],
//
    },
    {
      "gruppo": "Maggiori",
      "sigla": "13",
      "nome": "Tredicesima",
      "gradi": ["1", "3", "5", "7b", "9", "13"], // (11)
// V
    },
    {
      "gruppo": "Maggiori",
      "sigla": "6",
      "nome": "Sesta",
      "gradi": ["1", "3", "5", "6"],
// I, IV, V
    },
    {
      "gruppo": "Minori",
      "sigla": "m",
      "nome": "Minore",
      "gradi": ["1", "3b", "5"],
// II, III, VI
    },
    {
      "gruppo": "Minori",
      "sigla": "m7",
      "nome": "Minore settima",
      "gradi": ["1", "3b", "5", "7b"],
// II, III, VI
    },
    {
      "gruppo": "Minori",
      "sigla": "m+7",
      "nome": "Minore settima maggiore",
      "gradi": ["1", "3b", "5", "7"],
//
    },
    {
      "gruppo": "Minori",
      "sigla": "m9add",
      "nome": "Minore nona aggiunta",
      "gradi": ["1", "3b", "5", "9"],
//  II, VI
    },
    {
      "gruppo": "Minori",
      "sigla": "m7-9",
      "nome": "Minore nona minore",
      "gradi": ["1", "3b", "5", "7b", "9b"],
// III
    },
    {
      "gruppo": "Minori",
      "sigla": "m9",
      "nome": "Minore nona",
      "gradi": ["1", "3b", "5", "7b", "9"],
// II, VI
    },
    {
      "gruppo": "Minori",
      "sigla": "m6",
      "nome": "Minore sesta",
      "gradi": ["1", "3b", "5", "6"],
// II
    },
    {
      "gruppo": "Diminuiti",
      "sigla": "–5",
      "nome": "Quinta diminuita",
      "gradi": ["1", "3", "5b"],
//
    },
    {
      "gruppo": "Diminuiti",
      "sigla": "dim",
      "nome": "Minore quinta diminuita",
      "gradi": ["1", "3b", "5b"],
// VII
    },
    {
      "gruppo": "Diminuiti",
      "sigla": "ø7",
      "nome": "Semidiminuito",
      "gradi": ["1", "3b", "5b", "7b"],
// VII
    },
    {
      "gruppo": "Diminuiti",
      "sigla": "º7",
      "nome": "Diminuito",
      "gradi": ["1", "3b", "5b", "7bb"],
//
    },
    {
      "gruppo": "Aum",
      "sigla": "+5",
      "nome": "Aumentato",
      "gradi": ["1", "3", "5#"],
//
    },
    {
      "gruppo": "Aum",
      "sigla": "7+5",
      "nome": "Settima quinta aumentata",
      "gradi": ["1", "3", "5#", "7b"],
//
    },
    {
      "gruppo": "Sospesi",
      "sigla": "sus4",
      "nome": "Quarta sospesa",
      "gradi": ["1", "4", "5"],
// I, II, III, V, VI
    },
    {
      "gruppo": "Sospesi",
      "sigla": "7sus4",
      "nome": "Settima quarta sospesa",
      "gradi": ["1", "4", "5", "7b"],
// II, III, V, VI
    },
    {
      "gruppo": "Sospesi",
      "sigla": "sus2",
      "nome": "Seconda sospesa",
      "gradi": ["1", "2", "5"],
// I, II, IV, V, VI
    },
  ];

}