	/* Name Surname */

	// STL
	#include <map>
	#include <vector>
	#include <utility>

	// LLVM
	/*#include <llvm/Pass.h>
	#include <llvm/IR/LLVMContext.h>
	#include <llvm/IR/Function.h>
	#include <llvm/IR/Instructions.h>
	#include "llvm/Analysis/CFG.h"
	#include <llvm/Support/raw_ostream.h>
	#include <llvm/IR/InstIterator.h>
	#include <llvm/IR/Constants.h>*/
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
      							errs() << ai->getName()<< " allocated\n";//TODO
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
                   PointerType *Ais;
		};
	
		virtual bool runOnFunction(Function &F){
			std::map <std::string, VarInfo> varInitMap;
			for(BasicBlock &b : F.getBasicBlockList()){ //for each block found in function
					for (BasicBlock::iterator ii = b.begin(), ie = b.end(); ii != ie; ++ii) {  //Iterate over the instructions of each block
					          if (AllocaInst *ai = dyn_cast<AllocaInst>(&*ii)) { //If instruction is an allocation
						         if(ai->hasName()) //And it has a name
						            {
							      VarInfo newvar;
							      newvar.isInitialized = false;
							      newvar.isNotified = false;
                                          		      newvar.Ais = ai->getType();
 							      varInitMap[ai->getName().str()] = newvar;
							
						              }
			                                }
			                         if (CallInst *ci = dyn_cast<CallInst>(&*ii)) {
				                    //Do something with call intrustion
					            errs()<< ci->getCalledFunction()->getName()<<" function\n";

			                            }
			                        if (StoreInst *si = dyn_cast<StoreInst>(&*ii)) {
				                     if (si->getOperand(1)->hasName())
				                         {
							varInitMap[si->getOperand(1)->getName().str()].isInitialized = true;
				                         }
			                             }

			                       if (LoadInst *li = dyn_cast<LoadInst>(&*ii)) {
						 LoadInst* insertbefore = nullptr;
				
				                     std::string varName = li->getOperand(0)->getName().str();
				                      if (li->getOperand(0)->hasName() && varInitMap[varName].isInitialized == false && varInitMap[varName].isNotified == false)
				                          {

				                             //IntegerType *int_type = Type::getInt64Ty(context);
                                                           IntegerType *int_type = IntegerType::get(li->getContext(), 64);
				                           if(varInitMap[varName].Ais->getElementType()->isIntegerTy())
					                      {
					                            Value *num = ConstantInt::get(int_type, 10, true);
                                                                    Value *alloc = new AllocaInst(int_type, "int_addr", &b);
                                                                    //StoreInst *ptr = new StoreInst(num,alloc,false,&b);
									StoreInst *ptr = new StoreInst(num,alloc,false,insertbefore);
                   							li->getParent()->getInstList().insert(li, ptr);
					                      }
				                            else if(varInitMap[varName].Ais->getElementType()->isDoubleTy())
					                          {
					                            Value *num = ConstantInt::get(int_type, 30.0, true);
                                                                    Value *alloc = new AllocaInst(int_type, "double_addr", &b);
                                                                     //StoreInst *ptr = new StoreInst(num,alloc,false,&b);
								    StoreInst *ptr = new StoreInst(num,alloc,false,insertbefore);
									li->getParent()->getInstList().insert(li, ptr);
					                          }
				                            else if(varInitMap[varName].Ais->getElementType()->isFloatTy())
				                                   {
					                              Value *num = ConstantInt::get(int_type, 20.0, true);
                                                                      Value *alloc = new AllocaInst(int_type, "float_addr", &b);
                                                                       // StoreInst *ptr = new StoreInst(num,alloc,false,&b);
									StoreInst *ptr = new StoreInst(num,alloc,false,insertbefore);
                                                       			li->getParent()->getInstList().insert(li, ptr);
					                           }
                                                            }
				                          varInitMap[varName].isNotified = true;
			                          }
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
