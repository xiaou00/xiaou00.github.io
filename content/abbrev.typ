#let colim = $limits(op("colim"))$
#let Spec = $op("Spec")$
#let Frac = $op("Frac")$
#let Coeq = $op("coeq")$
#let res = $op("res")$
#let char = $"char"$
#let Eq = $op("Eq")$
#let tr = "tr"
#let Res = "Res" 
#let rad = "rad"
#let Ann = "Ann"

#let act = $arrow.half.cw$
#let wedge = $or$
#let smash = $and$
#let cop = $union.sq$
#let cup = $union$
#let cap = $inter$
#let tens = $times.o$
#let dtens = $times.o^bold("L")$
#let dtimes = $times^bold("R")$
#let semidirect = $\u{22ca}$
#let pairarrow = $\u{21c9}$
#let larr = $stretch(->)$
#let smile = $op(smile)$
#let veq = $#rotate(90deg, $=$)$
#let vdeq = $#rotate(90deg, $=:$)$


#let GL = $"GL"$
#let SL = $"SL"$

#let et = "ét"
#let DK = "DK"
#let Ner = $"N"_bullet$
#let fib = $"fib"$
#let cofib = $"cofib"$
#let coker = $"coker"$
#let dg = $"dg"$
#let trunl(args) = $tau_(<= args)$
#let trunr(args) = $tau_(>= args)$

#let Hom = "Hom"
#let Map = "Map"
#let Cov = "Cov"
#let Desc = "Desc"
#let Mul = "Mul"
#let Der = "Der"
#let Aut = "Aut"
#let End = "End"
#let Lan = "Lan"
#let Ran = "Ran"
#let Pic = "Pic"
#let Ext = "Ext"
#let Tor = "Tor"
#let Bar = "Bar"
#let Nm = "Nm"
#let Sym = "Sym"
#let LSym = "LSym"
#let Gr = "Gr"
#let Wh = "Wh"
#let Hilb = "Hilb"
#let Quot = "Quot"
#let Assem = "Assem"
#let opp = "op"
#let pr = "pr"
#let ev = "ev"
#let Spf = "Spf"
#let CH = "CH"
#let SqZ = $"SqZ"$
#let yo = context if target() == "html" {
  html.elem("mrow", attrs: (style: "font-style: normal; font-size: 0.9em"), [よ])
} else {
  text(size: 0.9em, style: "normal")[よ]
}

#let gl = $frak("gl")$
#let sl = $frak("sl")$

#let Fun = $bold(sans("Fun"))$
#let BiFun = $bold(sans("BiFun"))$
#let Exc = $bold(sans("Exc"))$
#let Act = $bold(sans("Act"))$
#let Env = $bold(sans("Env"))$
#let Set = $bold(sans("Set"))$
#let Open = $bold(sans("Open"))$
#let PSh = $bold(sans("PSh"))$
#let Sh = $bold(sans("Sh"))$
#let LRep = $bold(sans("LRep"))$
#let Ab = $bold(sans("Ab"))$
#let Ring = $bold(sans("Ring"))$
#let CRing = $bold(sans("CRing"))$
#let Mod = $bold(sans("Mod"))$
#let QCoh = $bold(sans("QCoh"))$
#let Grp = $bold(sans("Grp"))$
#let Sch = $bold(sans("Sch"))$
#let Top = $bold(sans("Top"))$
#let LRS = $bold(sans("LRS"))$
#let Aff = $bold(sans("Aff"))$
#let Cat = $bold(sans("Cat"))$
#let Grpd = $bold(sans("Grpd"))$
#let Ani = $bold(sans("Ani"))$
#let St = $bold(sans("St"))$
#let PSt = $bold(sans("PSt"))$
#let sSet = $bold(sans("sSet"))$
#let CG = $bold(sans("CG"))$
#let QCat = $bold(sans("QCat"))$
#let Sp = $bold(sans("Sp"))$
#let Ch = $bold(sans("Ch"))$
#let dgCat = $bold(sans("dgCat"))$
#let Kcat = $bold(sans("K"))$
#let Dcat = $bold(sans("D"))$
#let Fin = $bold(sans("Fin"))$
#let Op = $bold(sans("Op"))$
#let POp = $bold(sans("POp"))$
#let Comm = $bold(sans("Comm"))$
#let Assoc = $bold(sans("Assoc"))$
#let Alg = $bold(sans("Alg"))$
#let CAlg = $bold(sans("CAlg"))$
#let Mon = $bold(sans("Mon"))$
#let CMon = $bold(sans("CMon"))$
#let AlgSp = $bold(sans("AlgSp"))$
#let DMSt = $bold(sans("DMSt"))$
#let ArtSt = $bold(sans("ArtSt"))$
#let LieAlg = $bold(sans("LieAlg"))$
#let Vect = $bold(sans("Vect"))$
#let Rep = $bold(sans("Rep"))$
#let Lie = $bold(sans("Lie"))$
#let Perf = $bold(sans("Perf"))$
#let LMod = $bold(sans("LMod"))$
#let dga = $bold(sans("dgAlg"))$
#let Ind = $bold(sans("Ind"))$
#let sInd = $bold(sans("sInd"))$
#let cdga = $bold(sans("cdgAlg"))$
#let AniRing = $bold(sans("AniRing"))$
#let AniAlg = $bold(sans("AniAlg"))$
#let AniCAlg = $bold(sans("AniCAlg"))$
#let AniMod = $bold(sans("AniMod"))$
#let AugAlg = $bold(sans("AugAlg"))$
#let Poly = $bold(sans("Poly"))$
#let PrL = $bold(sans("Pr"))^"L"$

#let ideal = $lt.closed$
#let ad = $"ad"$

#let simp(str) = $bold(sans("s"))str$
#let cat(name) = $bold(sans(name))$

#let rightarrow = $stretch(->, size: #15pt)$
#let movebase(size, x) = text(baseline: size)[#x]
#let injlim = $display(limits(lim_(movebase(#(-1.9pt),rightarrow))))$
#let varinjlim(subscript) = $injlim_movebase(#(-2.8pt), subscript)$

#let leftarrow = $stretch(<-, size: #15pt)$
#let projlim = $display(limits(lim_(movebase(#(-1.9pt),leftarrow))))$
#let varprojlim(subscript) = $projlim_movebase(#(-2.8pt), subscript)$

