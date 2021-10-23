import random

# Soldier
class Soldier:
    def __init__(self, health, strength): # Constructor function es la de __init__,                                           es decir, con la que construyes el objecto 
        self.health = health
        self.strength = strength

    def attack(self):
        return self.strength

    def receiveDamage(self, damage):
        self.health -= damage

# Viking
class Viking(Soldier):
    
    def __init__(self, name, health, strength):
        super().__init__(health, strength)
        self.name = name

    def receiveDamage(self, damage):
        self.health -= damage

        if self.health > 0:
            return f'{self.name} has received {damage} points of damage'

        else:
            return f'{self.name} has died in act of combat'

    def battleCry(self):
        return 'Odin Owns You All!'

# Saxon
class Saxon(Soldier):
    
    def __init__(self, health, strength):
        super().__init__(health, strength)

    def receiveDamage(self, damage):
        self.health -= damage

        if self.health > 0:
            return f'A Saxon has received {damage} points of damage'

        else:
            return f'A Saxon has died in combat'

# War
class War:
    """Let's us have a Viking army and a Saxon army battle each other"""
    
    def __init__(self):
        self.vikingArmy = []
        self.saxonArmy = []

    def addViking(self, viking):
        self.vikingArmy.append(viking)

    def addSaxon(self, saxon):
        self.saxonArmy.append(saxon)

    def vikingAttack(self):
        # Se elige a un saxon aleatorio de saxonArmy
        saxon = random.choice(self.saxonArmy) 
        
        # Se elige la fuerza de un vikingo aleatorio de vikingArmy
        dmg_inflicted = random.choice(self.vikingArmy).strength
        
        # Se inflinge daño al saxon con base en la fuerza del vikingo
        outcome = saxon.receiveDamage(dmg_inflicted)

        # Se elimina al saxon de saxonArmy si es que murió
        if saxon.health <= 0:
            self.saxonArmy.remove(saxon)

        return outcome

    def saxonAttack(self):
        viking = random.choice(self.vikingArmy)
        dmg_inflicted = random.choice(self.saxonArmy).strength
        outcome = viking.receiveDamage(dmg_inflicted)

        if viking.health <= 0:
            self.vikingArmy.remove(viking)

        return outcome

    def showStatus(self):
        if not self.saxonArmy: #"If not" arroja False si una lista está vacía
            return 'Vikings have won the war of the century!'

        elif not self.vikingArmy:
            return 'Saxons have fought for their lives and survive another day...'

        else:
            return 'Vikings and Saxons are still in the thick of battle.'
