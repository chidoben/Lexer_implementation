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
		struct VarInfo {
		   bool isInitialized;
		   bool isNotified;
		};
		static const bool verbose = false;

		static char ID;
		DefinitionPass() : FunctionPass(ID) {}

		virtual void getAnalysisUsage(AnalysisUsage &au) const {
			au.setPreservesAll();
		}

		virtual bool runOnFunction(Function &F) {
        	std::map <std::string, VarInfo> varInitMap;
	        for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
	            for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
      				
      				if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii)) { //If instruction is an allocation
      					if(ai->hasName()) //And it has a name
      					{
      						VarInfo newvar;
      						varInitMap[ai->getName().str()] = newvar;
      						newvar.isInitialized = false;
      						newvar.isNotified = false;
      						if(verbose)
      							errs() << ai->getName()<< " declared\n";//TODO
      					}
					}
					
					if (StoreInst *si = dyn_cast<StoreInst>(&*ii)) {
						//errs() << "StoreInst: " << si->getNumOperands()<< "\n";
						if (si->getOperand(1)->hasName())
						{
      						varInitMap[si->getOperand(1)->getName().str()].isInitialized = true;
							if(verbose)
								errs() << si->getOperand(1)->getName()<< " initialized\n";
						}
					}
					
					if (LoadInst *li = dyn_cast<LoadInst>(&*ii)) {
						//errs() << "Load Instruction: " << li->getOperand(0)->getName() << " Is initialized:  " << varInitMap[li->getOperand(0)->getName().str()]<<"\n";
						std::string varName = li->getOperand(0)->getName().str();
						if (li->getOperand(0)->hasName() && varInitMap[varName].isInitialized == false && varInitMap[varName].isNotified == false)
						{
							if(verbose)
							{
								errs() << "Load Instruction: " << li->getOperand(0)->getName() << " Is initialized:  " << varInitMap[varName].isInitialized<<"\n";
							}else
							{
								errs() <<varName<<"\n";
							}
							varInitMap[varName].isNotified = true;
						}
					}
    			}

        	}

        	//Print all maps values
        	if(verbose)
        	{
				errs() << "new Block:\n";
				std::map<std::string, VarInfo>::iterator variablesMapIterator = varInitMap.begin();
				while (variablesMapIterator!=varInitMap.end())
				{
					errs()<<"Iterator: " << variablesMapIterator->first << "\n";
					errs()<<"    isInitialized: " << variablesMapIterator->second.isInitialized << "\n";
					errs()<<"    isNotified: " << variablesMapIterator->second.isNotified << "\n";
					variablesMapIterator++;
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



