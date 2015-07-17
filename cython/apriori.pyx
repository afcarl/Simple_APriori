# -*- coding: utf-8 -*-
"""
Created on Thu Jul 16 19:11:37 2015
Simple A-priori algorithm (Cython)
@author: Jose Jimenez
MIT License
"""

def a_priori(data, support):
    
    layers = []  
    
    ## Memory-wise search
    transactions = data.readlines()
    transactions = transactions[0].split("\r")  ## To be cleaned
    
    for i, transaction in enumerate(transactions):  # To be cleaned
        transactions[i] = transaction[:-1]          # 
    
    ## Perform first-pass on data
    candidates = first_pass(transactions, support)
    ## Append first layer of counts
    layers.append(candidates)
    old_candidates = candidates.keys()
    first_level = candidates.keys()
    
    cond = True
    k = 2
    
    while cond == True:
        new_candidates = generate_candidates(old_candidates, first_level, k)
        new_counts = {}
        # Check for higher level counts
        for transaction in transactions:
            words = transaction.split(",")
            words = set(words)
            for candidate in new_candidates:
                candi = set(candidate)
                inter = candi.intersection(words)
                if len(inter) == k:
                    try:
                        new_counts[str(candidate)] += 1
                    except:
                        new_counts[str(candidate)] = 1
                        
        k += 1
        if new_counts == {}:
            cond = False
            print "No combinations left at level {0}".format(k)
        else:
            new_counts2 = {k: v for k, v in new_counts.items() if v >= support}
            # Literal eval for consistency
            old_candidates = new_counts2.keys()
            
            for i, candidate in enumerate(old_candidates):
                old_candidates[i] = ast.literal_eval(candidate)
            
            layers.append(new_counts2)
            print "Now checking level {0} interactions. There are still {1} possible combinations".format(k, len(new_counts2.values()))

    return layers
    
    
       
        


# Performs a first pass on the data, returns a dictionary
# with counts
def first_pass(transactions, support):
    counts = {}
    for transaction in transactions:
        words = transaction.split(",")
        words = set(words)
        for word in words:
            try:
                counts[word] += 1
            except:
                counts[word] = 1
    
    ## Filter by support
        counts2 = {k: v for k, v in counts.items() if v >= support}            
    
    return counts2
        




# Receives a list of keys and raises a level on complexity,
# returns a list of tuples with the new candidates
def generate_candidates(previous_candidates, first_level, k):
    join = [(u, v) for u in previous_candidates for v in first_level]
    new_candidates = []
    drops = []
    for candidate in join:
        new = []
        for element in candidate:
            if isinstance(element, tuple):
                for item in element:
                    new.append(item)
            else:
                new.append(element)
        new_candidates.append(tuple(new))
        
        for i, candidate in enumerate(new_candidates):
            new_candidates[i] = set(candidate)
            new_candidates[i] = tuple(new_candidates[i])
            # Take only level k interactions
            if len(new_candidates[i]) < k:
                drops.append(i)
            
    # Avoid repetitions
    new_candidates2 = [v for i, v in enumerate(new_candidates) if i not in drops]
    new_candidates2 = list(set(new_candidates2))
    
    return new_candidates2
        
    
    
    
 
if __name__ ==  "__main__":
    
    import sys
    import ast
    import pprint as pp
    
    data = open(sys.argv[1])
    support = int(sys.argv[2])

    pp.PrettyPrinter(indent = 4)    
    
    print pp.pprint(a_priori(data, support))