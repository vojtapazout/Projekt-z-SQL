## **Analýza HDP, GINI a vliv času na cen potravin a reálné mzdy**



Tento projekt pracuje s datovými sadami. Cílem je analyzovat vývoj mezd, cen potravin a ekonomických ukazatelů v České republice a ve světě.



Výčet dat, které jsem použil na analýzu.



#### Mzdy

\- czechia\_payroll – Měsíční mzdy v různých odvětvích, regionech a časových obdobích.

\- czechia\_payroll\_calculation – Číselník způsobů výpočtu (např. průměrná mzda, medián).

\- czechia\_payroll\_industry\_branch – Číselník odvětví (např. stavebnictví, zdravotnictví).

\- czechia\_payroll\_unit – Jednotky měření (např. Kč, osoby).

\- czechia\_payroll\_value\_type – Typy hodnot (např. skutečnost, odhad).



#### Ceny potravin

\- czechia\_price – Historické ceny vybraných potravin v regionech ČR.

\- czechia\_price\_category – Kategorie potravin (např. mléčné výrobky, pečivo).



#### Regionální členění

\- czechia\_region – Kraje ČR dle klasifikace CZ-NUTS 2.

\- czechia\_district – Okresy ČR dle klasifikace LAU.



#### Globální data

\- countries – Základní informace o zemích (měna, hlavní město, národní jídlo).

\- economies – Ekonomické ukazatele států (HDP, GINI, daňová zátěž).





Z těchto dat jsem vytvořil 2 souhrnné tabulky



**t\_vojta\_pazout\_project\_SQL\_primary\_final** - kde lze najít sjednocená data mezd a potravin za českou republiku

**t\_vojta\_pazout\_project\_SQL\_secondary\_final** - kde lze najít dodatečná data evropských státech jako je HDP nebo GINI



#### Výzkumné otázky



1\. Rostou mzdy ve všech odvětvích, nebo v některých klesají?

2\. Kolik litrů mléka a kilogramů chleba si lze koupit za průměrnou mzdu v prvním a posledním období?

3\. Která kategorie potravin zdražuje nejpomaleji (nejnižší meziroční nárůst)?

4\. Existuje rok, kdy růst cen potravin výrazně převýšil růst mezd (>10 %)?

5\. Má růst HDP vliv na růst mezd a cen potravin ve stejném nebo následujícím roce?





#### Kontakt

Pro dotazy nebo spolupráci: vojtapazout@gmail.com







## Odpovědi na otázky:



##### 1\. otázka



Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?



###### Odpověď:



Z dostupných údajů vyplývá, že průměrné mzdy ve všech odvětvích nevykazovaly pouze růst, ale v některých letech také docházelo k poklesu. Tento pokles lze pozorovat především v období 2009–2016, kdy se na vývoji mezd negativně projevily dozvuky hospodářské krize.



Nejmenší pokles byl zaznamenán v roce 2013 v odvětví kulturní, zábavní a rekreační činnosti, kde mzdy klesly pouze o 0,05 % oproti předchozímu roku.

Naopak nejvýraznější pokles nastal také v roce 2013 v odvětví peněžnictví a pojišťovnictví, kde se mzdy snížily o 8,9 %.



Celkově lze tedy říci, že většina odvětví dlouhodobě vykazuje růst mezd, avšak v některých letech a sektorech docházelo k dočasnému poklesu, zejména v návaznosti na ekonomické výkyvy a krizi v letech po roce 2009.



##### 2\. otázka



Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?



###### Odpověď:



roce 2006 byla průměrná cena mléka 14,44 Kč za litr a chleba 16,12 Kč za kilogram. Při průměrné mzdě 20 754 Kč si tedy bylo možné koupit celkem přibližně 679 kusů (litrů a kilogramů) těchto základních potravin.



V roce 2018 činila průměrná cena mléka 19,82 Kč/l a chleba 24,24 Kč/kg. Průměrná mzda v tomto roce byla 32 536 Kč, což znamená, že si bylo možné pořídit zhruba 738 kusů (litrů a kilogramů) mléka a chleba dohromady.



Z těchto údajů vyplývá, že i přes růst cen potravin si lidé v roce 2018 mohli díky vyšším mzdám koupit více základních potravin než v roce 2006. To ukazuje na zlepšení reálné kupní síly obyvatel během sledovaného období.



#### 3\. otázka



Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?



##### Odpověď:



Z analýzy cenových údajů vyplývá, že nejpomaleji zdražovala kategorie cukru krystalového. Ve sledovaném období došlo dokonce k nepatrnému poklesu ceny o 0,09 %, což znamená, že tato potravina nejen že nezaznamenala růst ceny jako většina ostatních komodit, ale její cena se mírně snížila. Lze tedy říci, že cukr krystalový patří mezi potraviny s nejstabilnější cenou v rámci sledovaného období.



#### 4\. otázka



Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?



##### Odpověď:



Ve sledovaném období neexistuje rok, ve kterém by meziroční nárůst cen potravin byl výrazně vyšší než růst mezd o více než 10 %. Z dostupných dat vyplývá, že i když ceny potravin v některých letech rostly, rozdíl mezi tempem růstu cen a mezd nikdy nepřesáhl hranici deseti procentních bodů. Lze tedy konstatovat, že takový rok se nevyskytl.



#### 5\. otázka



Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?



##### Odpověď:



Z dostupných dat (roky 2007–2018) lze pozorovat, že růst hrubého domácího produktu (HDP) má obecně pozitivní vliv na růst mezd, a často také doprovází zvyšování cen potravin. Tento vztah ale není zcela přímý – existují roky, kdy se vývoj HDP, mezd a cen potravin vyvíjel odlišně.



Například v roce 2009, kdy do České republiky dorazila hospodářská krize a došlo k poklesu HDP o 4,66 %, reálné mzdy přesto vzrostly o 3,16 %. Tento růst lze pravděpodobně vysvětlit snahou firem a státu udržet kupní sílu obyvatel. Naopak ceny potravin klesly o 6,41 %, což mohlo být důsledkem snahy výrobců udržet poptávku a zajistit odbyt svých výrobků v období ekonomické nejistoty.



Podobná situace nastala v roce 2012, kdy HDP kleslo o 0,79 %, přesto mzdy vzrostly o 3,03 %. Ceny potravin se však zvýšily o 6,72 %, tedy více než dvojnásobně oproti růstu mezd. To naznačuje, že inflace v potravinářském sektoru může mít i jiné příčiny než samotný vývoj HDP, například vliv zemědělské produkce, dovozních cen či sezónních výkyvů.



Zajímavý je také vývoj v letech 2016–2017. V roce 2016 díky měnové intervenci České národní banky ceny potravin klesaly, což bylo důsledkem stabilní měnové politiky. Následující rok (2017) však po skončení intervencí došlo k výraznému růstu HDP, doprovázenému růstem mezd i cen potravin. To ukazuje, že hospodářský růst se často s určitým zpožděním promítá do zvyšování životních nákladů i platů obyvatel.



Statistická analýza navíc ukazuje, že korelace mezi mzdami a cenami potravin činí 0,43, zatímco korelace mezi HDP a cenami potravin je 0,487. Tyto hodnoty potvrzují středně silný pozitivní vztah – tedy že při růstu HDP či mezd mají ceny potravin tendenci růst také, i když tento vztah není úplně přímý ani jednoznačný.



Celkově lze tedy říci, že vývoj HDP, mezd a cen potravin spolu souvisí, avšak vliv HDP na ceny potravin a mzdy není okamžitý ani absolutní. Ekonomika reaguje se zpožděním a je ovlivněna i dalšími faktory, jako je měnová politika, inflace či situace na světových trzích.

