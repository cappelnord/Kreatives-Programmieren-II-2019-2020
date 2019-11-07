# Was wir zusammen besprichen haben

## Warum Patterns?

-   &ldquo;was&rdquo; <-> &ldquo;wie&rdquo;

    p = Pseries(0, 1, 10);
    p.next;
    
    q = p.asStream;
    q.next;
    
    r = p.asStream;
    r.next; 
    
    q.next; 
    
    [q.next, r.next] 


## Verschiedene Patterns


### List-Patterns

-   Pseq
-   Pser



#### Random-List-Patterns

-   Prand / Pxrand / Pwrand


#### Lacing

-   Place
-   Ppatlace


#### Random Patterns

- Pwhite
- Pbrown
- Pgauss


### Series

-   Pseries
-   Pgeom



### Filter Patterns

-   Pbindf
-   Padd
-   Pfindur


## Pbind / Events

-  Beziehnung Events und Pbind   
-   keys (degree, scale, etc.)


# Schreibt mir

Wie Patrick schon gesagt hat: Wenn ihr bei euren Projekten Fragen habt, oder auch allgemein Fragen über SuperCollider, dann schreibt mir! --> daniel.k.hopfner@gmail.com
