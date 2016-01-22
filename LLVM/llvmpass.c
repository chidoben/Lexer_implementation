/* Name Surname */

// STL
#include <map>
#include <vector>
#include <utility>

// LLVM
#include <llvm/Pass.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include "llvm/Analysis/CFG.h"
#include <llvm/Support/raw_ostream.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Constants.h>

using namespace llvm;

namespace {

class DefinitionPass  : public FunctionPass {
public:
	static char ID;
	DefinitionPass() : FunctionPass(ID) {}

	virtual void getAnalysisUsage(AnalysisUsage &au) const {
		au.setPreservesAll();
	}
	virtual bool runOnFunction(Function &F) {
            //Iterate over all instructions inst_begin(F) inst_end(E) inst_iterator
            //check for allocation operators
            //if(alloc dynamic map<>)
            //check instruction operators
            //????????????
            errs() << "def-pass\n";
	    return false;
	}
};

class FixingPass : public FunctionPass {
public:
	static char ID;
	FixingPass() : FunctionPass(ID){}

	virtual bool runOnFunction(Function &F){
            // TODO
            errs() << "fix-pass\n";
	    return true;
	}
};
} // namespace


char DefinitionPass::ID = 0;
char FixingPass::ID = 1;

// Pass registrations
static RegisterPass<DefinitionPass> X("def-pass", "Reaching definitions pass");
static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");
