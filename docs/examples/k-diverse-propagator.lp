#script(python)
import clingo
"""
Get answer sets with distance k.
"""

""" Distance """
def distance(l1, l2):
    l3 = list(set(l1) & set(l2)) # Intersect
    l4 = list(set(l1)-set(l3))   # Difference
    l5 = list(set(l2)-set(l3))   # Difference
    return len(l4)+len(l5)

class Dissimilar:
    def __init__(self, k):
        self.__states = []
        self.__literals = []
        self.__k = k

    """
    Init Method 
    """
    def init(self, init):
        Dissimilar.__max_dist = 0
        init.check_mode = clingo.PropagatorCheckMode.Total
        
        for thread_id in range(len(self.__states), init.number_of_threads):
            self.__states.append([])

        for atom in init.symbolic_atoms:
            lit = init.solver_literal(atom.literal)
            value = init.assignment.value(lit)
            if lit not in self.__literals and init.assignment.value(lit) is None:
                self.__literals.append(lit)
        print "number of unassigned literals:", len(self.__literals)

    """
    Check Method on total assignments
    """
    def check(self, control):
        state = self.__states[control.thread_id]
        literals = sorted(self.__literals)
        k = self.__k
        answer = []
        false_lits = []
        diverse = True
        
        ## Check assignments
        for lit in literals:
            value = control.assignment.value(lit)
            if value == True:
                if lit not in answer:
                    answer.append(lit)
            elif value == False:
                if lit not in false_lits:
                    false_lits.append(-lit)

        ## If an answer set is already given
        if state:
            for assignment in state:
                if assignment != answer:
                    d = distance(assignment, answer)
                    #print "Distance between %s and %s = %s"%(assignment, answer, d)
                    if d > Dissimilar.__max_dist:
                        Dissimilar.__max_dist = d
                    if d < k:
                        diverse = False
                        if not control.add_nogood(answer+false_lits):
                            return
            if diverse:
                if answer not in state:
                    state.append(list(answer))

        ## The first answer set
        else:
            state.append(answer)

def main(control):
    models = []
    total = 0
    k = int(str(control.get_const("k")))
    v = str(control.get_const("v"))
    if v == "true":
        v = True
    else:
        v = False
    control.ground([("base", [])])
    control.register_propagator(Dissimilar(k))

    if v:
        control.solve(None, lambda model: models.append(model.symbols(shown=True)))
    else:
        control.solve()
    
    d = Dissimilar._Dissimilar__max_dist
    print ""
    print "Max distance between two answer sets:", d

    if v:
        print ""
        for i in range(len(models)):
            for j in range(i+1,len(models)):
                partial = distance(models[i], models[j])
                print "Distance between %s and %s = %s"%(models[i], models[j], partial)
                total += partial
        print "Total distance: %s"%total

#clingo k-distance.py test3.lp --sign-def=rnd --sign-fix --rand-freq=1 --seed=$RANDOM --enum-mode=record 0 -c k=3 -c n=15 -c v=true       
#end.
%
#const k=3.
#const v="False".

%% Your ASP program here
{a;b;c;d;e;f}.
