# Atomic Peek Cipher

**Experimental symmetric stream/block cipher built on algebraic chaos and deliberate mathematical cruelty**

### Origins & Mathematical Backbone
https://github.com/4i4in/algebraic_trick_abusing_Wick

Most of the dirty CD algebra, Wick rotation abuses, matrix projections and foundational limits come from there.

### Key Features (full transparency edition)

- symmetric **lossy** stream cipher  
- the **key is the only atomic anchor** — nothing else gives attacker any meaningful foothold  
- no known analytical attacks (januari 2026)  
- **zero formal security proof** — we lean on heuristic hardness + deep ties to unprovable regimes:  
  • Gödel incompleteness (axiomatic limits)  
  • Banach–Tarski & related paradoxes (dimensions ≥4)  
- GMS2 version → hard limit ~52 effective bits (engine constraints)  
- Python version → practically unlimited key length  

### Implementations status (Jan 2026)

| Platform          | Key length           | Status              | Notes                              |
|-------------------|----------------------|---------------------|------------------------------------|
| GameMaker Studio 2| ≤ ~52 effective bits | stable prototype    | ver 3py 5gms no patterns found     |
| Python            | arbitrary (256+ bit) | working rewrite     | currently under long-key torture   |

Treat this as cryptographic performance art / intellectual provocation / very strange hobby project.


This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).
Commercial use of this software (including but not limited to SaaS, hosting as a service, or any paid offering) requires a separate commercial license.
Contact: [4i4in(at)protonmail.com] for licensing inquiries.

Have fun!

//version 3: cipher_base_n_03.py 

Pearson r = -0.0 (p-value = 1.0), no gradient, no structures; nothing I can find;

