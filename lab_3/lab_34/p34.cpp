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
    #include <llvm/IR/DerivedTypes.h>

	using namespace llvm;

	namespace {


	class DefinitionPass  : public FunctionPass {
	public:
		struct VarInfo {
		   bool isInitialized;
		   bool isNotified;
		};
		static const bool verbose = true;

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
      						newvar.isInitialized = false;
      						newvar.isNotified = false;
									varInitMap[ai->getName().str()] = newvar;
      						if(verbose)
      							errs() << ai->getName()<< " alocated\n";//TODO
      					}
					}
					if (CallInst *ci = dyn_cast<CallInst>(&*ii)) {
						//Do something with call intrustion
							errs()<< ci->getCalledFunction()->getName()<<" function\n";

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
		struct VarInfo {
		   bool isInitialized;
		   bool isNotified;
			 AllocaInst *Ais;
           std::string InitAns = "No";
           std::string varType;
		};
		static const bool verbose = true;

		virtual bool runOnFunction(Function &F){
			std::map <std::string, VarInfo> varInitMap;
			for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
                for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
					if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii))
					{ //If instruction is an allocation
						if(ai->hasName()) //And it has a name
						{
							VarInfo newvar;
							newvar.isInitialized = false;
							newvar.isNotified = false;
							newvar.Ais = ai;
 							std::string VarName = ai->getName().str();
 							varInitMap[VarName] = newvar;
                            if(varInitMap[VarName].Ais->getAllocatedType()->isDoubleTy())
                            {
                                varInitMap[VarName].varType = "Double";
                            }
                            else if(varInitMap[VarName].Ais->getAllocatedType()->isFloatTy())
                            {
                                varInitMap[VarName].varType = "Float";
                            }
                            else if(varInitMap[VarName].Ais->getAllocatedType()->isIntegerTy())
                            {
                                varInitMap[VarName].varType = "Integer";
                            }
							if(verbose)
								errs() << "alocated Variable "<<VarName<< "\n";
						}
                    }
                if (CallInst *ci = dyn_cast<CallInst>(&*ii)) {
                    //Do something with call intrustion
                       if(verbose) errs()<<"call Function : " <<ci->getCalledFunction()->getName()<<" \n";
                }
                if (StoreInst *si = dyn_cast<StoreInst>(&*ii)) {
                    if (si->getOperand(1)->hasName())
                    {
                        varInitMap[si->getOperand(1)->getName().str()].isInitialized = true;
                        varInitMap[si->getOperand(1)->getName().str()].InitAns = "YES";
                        if(verbose)
                            errs() <<"variable "<< si->getOperand(1)->getName()<< " : is initialized\n";
                    }
                }
                if (LoadInst *li = dyn_cast<LoadInst>(&*ii))
                {
                    if (li->getOperand(0)->hasName())
                    {
                        std::string varName = li->getOperand(0)->getName().str();

                        if(verbose)
                        {
                            errs() << "Load Instruction: \n Is Variable " << varName << " initialized?  " << varInitMap[varName].InitAns <<"\n Variable type = "<<varInitMap[varName].varType <<"\n";
                        }else
                        {
                            errs() <<varName<<"\n";
                        }
                        if( varInitMap[varName].isInitialized == false && varInitMap[varName].isNotified == false)
                        {
                            varInitMap[varName].isNotified = true;
                            if (varInitMap[varName].varType == "Double")
                            {
                                double d_init = 30.0;
                                if(verbose) errs()<< "intializing var ..    value =" << d_init<<"\n";
                                Value *num = ConstantFP::get(Type::getDoubleTy(b.getContext()), d_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertBefore(li);

                            }
                            else if (varInitMap[varName].varType == "Float")
                            {
                                float f_init = 20.0;
                                if(verbose) errs()<< "intializing var ..    value =" << f_init<<"\n";
                                Value *num = ConstantFP::get(Type::getFloatTy(b.getContext()), f_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertBefore(li);
                            }
                            else if (varInitMap[varName].varType == "Integer")
                            {
                                int i_init = 10 ;
                                if(verbose) errs()<< "intializing var ..    value =" << i_init<<"\n";
                                Value *num = ConstantInt::get(Type::getInt32Ty(b.getContext()), i_init);
                                StoreInst *my_store = new StoreInst(num,varInitMap[varName].Ais);
                                my_store->insertBefore(li);
                            }
                            else
                            {
                                errs() << " unknown type";
                            }

                        }
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
