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
	#include "llvm/Support/CFG.h"
	#include <llvm/Support/raw_ostream.h>
	#include <llvm/Support/InstIterator.h>
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
	        for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
	            for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
      				if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii)) { //If instruction is an allocation
      					if(!ai->getName().empty()) //And it has a name
      						errs() << ai->getName()<< "\n";	//print it
					}
    			}
        	}
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



